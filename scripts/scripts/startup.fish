# use `crontab -e`
# and in it write `@reboot /usr/bin/fish ~/scripts/startup.fish`
# to run this

cd ~/playground/tailpin
go run . &

cd ~
# do something else...

