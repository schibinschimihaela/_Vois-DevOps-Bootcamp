def test_logs(client, mocker):
    # Mock DynamoDB table.scan
    mock_table = mocker.MagicMock()
    mock_table.scan.return_value = {
        "Items": [
            {
                "ip": "1.1.1.1",
                "country": "US",
                "city": "New York",
                "isp": "Test ISP",
                "timestamp": "2024-01-01T00:00:00Z"
            }
        ]
    }
    mocker.patch('app.services.logs.table', mock_table)
    
    response = client.get("/logs")
    
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 1
    assert data[0]["ip"] == "1.1.1.1"
    assert data[0]["country"] == "US"

def test_purge_logs(client, mocker):
    # Mock DynamoDB operations
    mock_table = mocker.MagicMock()
    mock_table.scan.return_value = {
        "Items": [
            {"ip": "1.1.1.1"},
            {"ip": "2.2.2.2"},
            {"ip": "3.3.3.3"}
        ]
    }
    mocker.patch('app.services.logs.table', mock_table)
    
    response = client.delete("/logs")
    
    assert response.status_code == 200
    assert response.json()["deleted"] == 3