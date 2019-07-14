#!/bin/bash
# coding: utf-8

function main {

	# コンテナイメージをビルドして実行します。
	sudo docker-compose up --build
	# sudo docker-compose up

	# コンテナを停止してイメージを削除します。
	sudo docker-compose down --rmi all
	# sudo docker-compose down

	# sudo docker-compose rm --stop -v
}

main;
