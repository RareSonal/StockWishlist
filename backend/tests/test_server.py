import sys
import os
import pytest
from unittest import mock
from unittest.mock import MagicMock

# Fix the import path for 'server.py'
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from server import app  # Now 'server' should be importable
import pyodbc

@pytest.fixture
def client():
    with app.test_client() as client:
        yield client

# Helper function to mock pyodbc connection with context management
def make_mock_connection(mock_cursor):
    mock_conn = MagicMock()
    mock_conn.cursor.return_value = mock_cursor

    mock_context = MagicMock()
    mock_context.__enter__.return_value = mock_conn
    mock_context.__exit__.return_value = None

    return mock_context

# ------------------ Tests ------------------

def test_login_valid(client):
    mock_cursor = mock.Mock()
    mock_cursor.fetchone.return_value = (1,)  # User found
    mock_connect = make_mock_connection(mock_cursor)

    with mock.patch.object(pyodbc, 'connect', return_value=mock_connect):
        response = client.post('/login', json={
            'email': 'test@example.com',
            'password': 'password123'
        })
        assert response.status_code == 200
        assert response.json['success'] is True


def test_login_invalid(client):
    mock_cursor = mock.Mock()
    mock_cursor.fetchone.return_value = None  # No user found
    mock_connect = make_mock_connection(mock_cursor)

    with mock.patch.object(pyodbc, 'connect', return_value=mock_connect):
        response = client.post('/login', json={
            'email': 'test@example.com',
            'password': 'wrongpassword'
        })
        assert response.status_code == 401
        assert response.json['success'] is False


def test_get_stocks(client):
    mock_cursor = mock.Mock()
    mock_cursor.description = [('id',), ('name',), ('quantity',)]
    mock_cursor.fetchall.return_value = [(1, 'Stock 1', 10)]
    mock_connect = make_mock_connection(mock_cursor)

    with mock.patch.object(pyodbc, 'connect', return_value=mock_connect):
        response = client.get('/stocks')
        assert response.status_code == 200
        assert isinstance(response.json, list)
        assert len(response.json) == 1
        assert response.json[0]['name'] == 'Stock 1'


def test_get_wishlist(client):
    mock_cursor = mock.Mock()
    mock_cursor.description = [('user_id',), ('stock_id',), ('name',)]
    mock_cursor.fetchall.return_value = [(1, 1, 'Stock 1')]
    mock_connect = make_mock_connection(mock_cursor)

    with mock.patch.object(pyodbc, 'connect', return_value=mock_connect):
        response = client.get('/wishlist')
        assert response.status_code == 200
        assert isinstance(response.json, list)
        assert len(response.json) == 1
        assert response.json[0]['name'] == 'Stock 1'
