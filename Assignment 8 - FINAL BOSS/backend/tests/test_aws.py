def test_aws_status(client, mocker):
    mock_sts_client = mocker.MagicMock()
    mock_sts_client.get_caller_identity.return_value = {
        "Account": "123456789012",
        "Arn": "arn:aws:iam::123456789012:role/test-role"
    }
    
    mock_boto_client = mocker.patch('boto3.client')
    mock_boto_client.return_value = mock_sts_client
    
    mocker.patch('os.getenv', return_value='eu-west-1')
    
    response = client.get("/aws/status")
    
    assert response.status_code == 200
    data = response.json()
    assert data["region"] == "eu-west-1"
    assert data["account"] == "123456789012"
    assert "arn" in data