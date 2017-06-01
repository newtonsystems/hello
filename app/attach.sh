while true
do
        inotifywait /app
        pkill python
done
