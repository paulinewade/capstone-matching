PID=$(ps -aux | grep capstone-matching-deploy | head -n 1 | awk '{ print $2 }')
echo attempting to kill PID=$PID
kill -9 $PID || true