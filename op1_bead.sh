function total_files {
    find $1 -type f | wc -l
}

function total_directories {
    find $1 -type d | wc -l
}

function total_archived_directories {
    tar -tzf $1 | grep  /$ | wc -l
}
    
function total_archived_files {
    tar -tzf $1 | grep -v /$ | wc -l
}

function dirinfo {

    if [ -z $1 ]; then
        user=$(whoami)
    else
        if [ ! -d "/home/$1" ]; then
                echo "Directory doesn't exist."
                exit 1
        fi
        user=$1
    fi

    input=/home/$user
    output=${user}_home_$(date +%Y-%m-%d_%H%M%S).txt
    backup=${user}_home_$(date +%Y-%m-%d_%H%M%S).tar.gz
    totalf=$(total_files $input 2> /dev/null)
    totald=$(total_directories $input 2> /dev/null)

    echo "************ Home information *************" >> $output
    echo "User:  $user" > $output
    echo "Your Bash shell version is: $BASH_VERSION." >> $output
    echo "$totalf files in the home directory" >> $output
    echo "$totald directories in the home directory" >> $output
    ls -dl ~ >> $output

    echo "Backup file of home is being created.."
    tar -czf $backup $input 2> /dev/null

    src_files=$( total_files $input 2> /dev/null)
    src_directories=$( total_directories $input 2> /dev/null)

    echo "$src_files files' been archived" >> $output
    echo "$src_directories directories' been archived" >> $output
    echo "Home directory information's been listed in $output"
    echo "Home backup's been created: $backup"
    echo "Archived home directory information's been listed in $output"
}
dirinfo

