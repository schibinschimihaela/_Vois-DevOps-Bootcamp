install:
	pip install -r requirements.txt

run:
	python cli.py

clean:
	rm -rf __pycache__ *.log

create-db:
	python aws/dynamodb.py create

purge-db:
	python aws/dynamodb.py purge

scan-ip:
	python cli.py --scan
