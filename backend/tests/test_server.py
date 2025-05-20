import sys
import os
import pytest
from unittest import mock
from unittest.mock import MagicMock
import psycopg2
import jwt

# Fix the import path for 'server.py'
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from server import app

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

def test_get_stocks(client):
    mock_cursor = mock.Mock()
    mock_cursor.description = [('id',), ('name',), ('quantity',)]
    mock_cursor.fetchall.return_value = [(1, 'Stock 1', 10)]
    mock_connect = make_mock_connection(mock_cursor)

    token = jwt.encode({'sub': 'test-user'}, 'dev-secret', algorithm='HS256')
    headers = {
        'Authorization': f'Bearer {token}'
    }

    with mock.patch.object(psycopg2, 'connect', return_value=mock_connect):
        response = client.get('/stocks', headers=headers)
        assert response.status_code == 200
        assert isinstance(response.json, list)
        assert len(response.json) == 1
        assert response.json[0]['name'] == 'Stock 1'

def test_get_wishlist(client):
    mock_cursor = mock.Mock()
    mock_cursor.description = [('user_sub',), ('stock_id',), ('name',)]
    mock_cursor.fetchall.return_value = [('test-user', 1, 'Stock 1')]
    mock_connect = make_mock_connection(mock_cursor)

    headers = {
        'Authorization': 'Bearer ' + jwt.encode({'sub': 'test-user'}, 'dev-secret', algorithm='HS256')
    }

    with mock.patch.object(psycopg2, 'connect', return_value=mock_connect):
        response = client.get('/wishlist', headers=headers)
        assert response.status_code == 200
        assert isinstance(response.json, list)
        assert len(response.json) == 1
        assert response.json[0]['name'] == 'Stock 1'

def test_add_to_wishlist(client):
    mock_cursor = mock.Mock()
    mock_cursor.fetchone.return_value = (1,)  # Stock available
    mock_connect = make_mock_connection(mock_cursor)

    headers = {
        'Authorization': 'Bearer ' + jwt.encode({'sub': 'test-user'}, 'dev-secret', algorithm='HS256')
    }

    with mock.patch.object(psycopg2, 'connect', return_value=mock_connect):
        response = client.post('/wishlist', json={'stock_id': 1}, headers=headers)
        assert response.status_code == 200
        assert response.json['message'] == 'Stock added to wishlist'

def test_remove_from_wishlist(client):
    mock_cursor = mock.Mock()
    mock_cursor.fetchone.return_value = (1,)  # Stock exists
    mock_connect = make_mock_connection(mock_cursor)

    headers = {
        'Authorization': 'Bearer ' + jwt.encode({'sub': 'test-user'}, 'dev-secret', algorithm='HS256')
    }

    with mock.patch.object(psycopg2, 'connect', return_value=mock_connect):
        response = client.delete('/wishlist', json={'stock_id': 1}, headers=headers)
        assert response.status_code == 200
        assert response.json['message'] == 'Stock removed from wishlist'
