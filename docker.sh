docker-compose down
docker-compose build
docker-compose up -d
docker-compose run app rails db:create
docker-compose run app rails db:migrate
docker-compose run app rails sample_data:generate
docker-compose run app npm run dev-build
