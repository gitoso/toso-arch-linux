# Host Info
read -p "Hostname: " u_HOSTNAME
while true
do
    read -p "Root Password: " u_ROOTPASS
    read -p "Root Password Confirmation: " u_ROOTPASSCONFIRM
    if [ "$u_ROOTPASS" != "" ]
    then
        if [ "$u_ROOTPASS" == "$u_ROOTPASSCONFIRM" ]
        then
            break
        fi
    fi
    echo "Invalid Confirmation"
done
read -p "Username: " u_USERNAME
while true
do
    read -p "User Password: " u_USERPASS
read -p "User Password Confirmation: " u_USERPASSCONFIRM
    if [ "$u_USERPASS" != "" ]
    then
        if [ "$u_USERPASS" == "$u_USERPASSCONFIRM" ]
        then
            break
        fi
    fi
    echo "Invalid Confirmation"
done

# Machine Info
while true
do
    echo "CPU Brand?"
    echo "   1. Intel"
    echo "   2. AMD"
    read -p "Option: " cpu_type_input
    if [ "$cpu_type_input" == "1" ]
    then
        cpu_type="intel"
        break
    elif [ "$cpu_type_input" == "2" ]
    then
        cpu_type="amd"
        break
    fi
    clear
done

while true
do
    echo "GPU Brand?"
    echo "   1. Intel"
    echo "   2. Nvidia"
    echo "   3. AMD"
    read -p "Option: " gpu_type_input
    if [ "$gpu_type_input" == "1" ]
    then
        gpu_type="intel"
        break
    elif [ "$gpu_type_input" == "2" ]
    then
        gpu_type="nvidia"
        break
    elif [ "$gpu_type_input" == "3" ]
    then
        gpu_type="amd"
        break
    fi
    clear
done