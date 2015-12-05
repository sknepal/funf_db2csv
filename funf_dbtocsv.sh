#!/bin/bash
if hash sqlite3 2>/dev/null; then
        echo "SQLite is available."
   else
        echo "Installing SQlite"
	sudo apt-get install -qq --force-yes sqlite3 > /dev/null;
fi
if hash go 2>/dev/null; then
        echo "Go is available"
   else
        echo "Installing Go"
	sudo apt-get install -qq --force-yes golang > /dev/null
	mkdir ~/gocode
	echo 'export GOPATH=~/gocode' >> ~/.bashrc
	echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
	export GOPATH=~/gocode
	export PATH=$PATH:$GOPATH/bin
	echo ""
	echo "Note: On your next run, if you get an error saying GOPATH not found, then type : 'source ~/.bashrc' on your terminal first."
	echo ""
fi
if hash json2csv 2>/dev/null; then
        echo "json2csv is available."
   else
        echo "Installing json2csv"
	go get github.com/jehiah/json2csv
fi

mkdir csv
        echo "Retrieving the Call details from the database."
	sqlite3 merged_data.db "SELECT value FROM data WHERE probe LIKE '%call%';" > csv/calls
	sed -i 's/_id/id/g' csv/calls
	echo "Exporting to csv/calls.csv."
	cat csv/calls | json2csv -p -k id,date,duration,name,number,numberlabel,numbertype,timestamp,type > csv/calls.csv
	rm csv/calls
	echo ""

	echo "Retrieving the SMS details from the database."
	sqlite3 merged_data.db "SELECT value FROM data WHERE probe LIKE '%sms%';" > csv/sms
	echo "Exporting to csv/sms.csv."
	cat csv/sms | json2csv -p -k address,body,date,locked,person,protocol,read,reply_path_present,status,subject,thread_id,timestamp,type,service_center > csv/sms.csv
	rm csv/sms
	echo ""

echo "Done."


