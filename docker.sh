docker-compose down
docker-compose build
docker-compose up -d
docker-compose run app rails db:create
docker-compose run app rails db:migrate:reset # 前回の起動時に入れたテストデータを全部消す
docker-compose run app rails sample_data:generate