def test_fetch_electricity_balance():
    url = "https://xgfy.sit.edu.cn/unifri-flow/WF/Comm/ProcessRequest.do?DoType=DBAccess_RunSQLReturnTable"
    import requests
    session = requests.Session()
    response = session.post(url, params={
        "SQL": "select * from sys_room_balance where RoomName='105604';"
    }, headers={
        "Cookie": "FK_Dept=B1101"
    })
    response.raise_for_status()
    print(response.content)


test_fetch_electricity_balance()
