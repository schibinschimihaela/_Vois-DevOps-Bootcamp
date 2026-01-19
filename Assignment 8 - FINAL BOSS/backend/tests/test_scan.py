def test_scan(client, mocker):
    # Mock requests GLOBAL - înainte ca orice modul să-l importe
    mock_requests = mocker.patch('app.api.ipify.requests')
    mock_ipify_response = mocker.MagicMock()
    mock_ipify_response.json.return_value = {"ip": "1.2.3.4"}
    
    mock_geo_response = mocker.MagicMock()
    mock_geo_response.json.return_value = {
        "country": "Romania",
        "city": "Bucharest",
        "isp": "Test ISP"
    }
    
    # side_effect pentru a returna răspunsuri diferite la apeluri succesive
    mock_requests.get.side_effect = [mock_ipify_response, mock_geo_response]
    
    # Mock și în geolocation
    mocker.patch('app.api.geolocation.requests', mock_requests)
    
    # Mock DynamoDB table.put_item
    mock_table = mocker.MagicMock()
    mocker.patch('app.services.logs.table', mock_table)
    
    response = client.get("/scan")
    
    assert response.status_code == 200
    data = response.json()
    assert data["ip"] == "1.2.3.4"
    assert data["country"] == "Romania"
    assert data["city"] == "Bucharest"
    assert data["isp"] == "Test ISP"
    
    # Verifică că apelurile au fost făcute
    assert mock_requests.get.call_count == 2
    mock_table.put_item.assert_called_once()