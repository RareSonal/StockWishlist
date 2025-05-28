import boto3
import sys
import os
import pytest
import jwt
import psycopg2
from unittest import mock
from unittest.mock import MagicMock
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import serialization

# Fix the import path for 'server.py'
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from server import app

# Generate RSA key pair for RS256 token signing
private_key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
public_key = private_key.public_key()
public_pem = public_key.public_bytes(
    encoding=serialization.Encoding.PEM,
    format=serialization.PublicFormat.SubjectPublicKeyInfo
)

@pytest.fixture
def client():
    with app.test_client() as client:
        yield client

# Helper function to mock psycopg2 connection with context management
def make_mock_connection(mock_cursor):
    mock_conn = MagicMock()
    mock_conn.cursor.return_value = mock_cursor

    mock_context = MagicMock()
    mock_context.__enter__.return_value = mock_conn
    mock_context.__exit__.return_value = None

    return mock_context

def generate_rs256_token():
    payload = {
        'email': 'test@example.com',
        'iat': 0,
        'exp': 9999999999,
    }
    token = jwt.encode(payload, private_key, algorithm='RS256')
    # jwt.encode() returns str in PyJWT>=2.x
    if isinstance(token, bytes):
        token = token.decode('utf-8')
    return token

@mock.patch('server.decode_token')
@mock.patch('server.get_user_id_from_email')
def test_get_stocks(mock_get_user_id, mock_decode_token, client):
    mock_cursor = mock.Mock()
    mock_cursor.description = [('id',), ('name',), ('quantity',)]
    mock_cursor.fetchall.return_value = [(1, 'Stock 1', 10)]
    mock_connect = make_mock_connection(mock_cursor)

    mock_decode_token.return_value = {'email': 'test@example.com'}
    mock_get_user_id.return_value = 1

    token = generate_rs256_token()
    headers = {'Authorization': f'Bearer {token}'}

    with mock.patch.object(psycopg2, 'connect', return_value=mock_connect):
        response = client.get('/stocks', headers=headers)
        assert response.status_code == 200
        assert isinstance(response.json, list)
        assert len(response.json) == 1
        assert response.json[0]['name'] == 'Stock 1'

@mock.patch('server.decode_token')
@mock.patch('server.get_user_id_from_email')
def test_get_wishlist(mock_get_user_id, mock_decode_token, client):
    mock_cursor = mock.Mock()
    mock_cursor.description = [('user_id',), ('stock_id',), ('name',)]
    mock_cursor.fetchall.return_value = [(1, 1, 'Stock 1')]
    mock_connect = make_mock_connection(mock_cursor)

    mock_decode_token.return_value = {'email': 'test@example.com'}
    mock_get_user_id.return_value = 1

    token = generate_rs256_token()
    headers = {'Authorization': f'Bearer {token}'}

    with mock.patch.object(psycopg2, 'connect', return_value=mock_connect):
        response = client.get('/wishlist', headers=headers)
        assert response.status_code == 200
        assert isinstance(response.json, list)
        assert len(response.json) == 1
        assert response.json[0]['name'] == 'Stock 1'

@mock.patch('server.decode_token')
@mock.patch('server.get_user_id_from_email')
def test_add_to_wishlist(mock_get_user_id, mock_decode_token, client):
    mock_cursor = mock.Mock()
    mock_cursor.fetchone.return_value = (1,)  # Stock available
    mock_connect = make_mock_connection(mock_cursor)

    mock_decode_token.return_value = {'email': 'test@example.com'}
    mock_get_user_id.return_value = 1

    token = generate_rs256_token()
    headers = {'Authorization': f'Bearer {token}'}

    with mock.patch.object(psycopg2, 'connect', return_value=mock_connect):
        response = client.post('/wishlist', json={'stock_id': 1}, headers=headers)
        assert response.status_code == 200
        assert response.json['message'] == 'Stock added to wishlist'

@mock.patch('server.decode_token')
@mock.patch('server.get_user_id_from_email')
def test_remove_from_wishlist(mock_get_user_id, mock_decode_token, client):
    mock_cursor = mock.Mock()
    mock_cursor.fetchone.return_value = (1,)  # Stock exists
    mock_connect = make_mock_connection(mock_cursor)

    mock_decode_token.return_value = {'email': 'test@example.com'}
    mock_get_user_id.return_value = 1

    token = generate_rs256_token()
    headers = {'Authorization': f'Bearer {token}'}

    with mock.patch.object(psycopg2, 'connect', return_value=mock_connect):
        response = client.delete('/wishlist', json={'stock_id': 1}, headers=headers)
        assert response.status_code == 200
        assert response.json['message'] == 'Stock removed from wishlist'

def test_login_failure_invalid_credentials(client):
    with mock.patch('server.boto3.client') as mock_boto_client:
        mock_cognito = MagicMock()
        mock_cognito.initiate_auth.side_effect = Exception("User not authorized")
        mock_boto_client.return_value = mock_cognito

        response = client.post('/login', json={'username': 'invalid', 'password': 'wrong'})
        assert response.status_code == 401
        assert 'error' in response.json
        assert response.json['error'] == 'Invalid credentials'
