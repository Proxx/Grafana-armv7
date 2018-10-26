URL=$(wget -O - https://grafana.com/grafana/download?platform=arm | grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' | sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//' | grep armv7.tar.gz)
echo "wget -O /tmp/grafana.tar.gz $($URL)"



