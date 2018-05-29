#!/bin/sh

set -e


ESC_D="\033[0;30m"
ESC_G="\033[0;32m"
ESC_Y="\033[0;33m"
ESC_P="\033[0;35m"
ESC_C="\033[0;36m"
ESC_BD="\033[1;30m"
ESC_BR="\033[1;31m"
ESC_BG="\033[1;32m"
ESC_BY="\033[1;33m"
ESC_BB="\033[1;34m"
ESC_BP="\033[1;35m"
ESC_BC="\033[1;36m"
ESC_BW="\033[1;37m"
ESC_RESET="\033[0m"



formatted_print () {
	local msg="$1"
	local esc_start="$2"
	local esc_em="$3"
	local esc_strong="$4"
	
        local fmsg="$(echo "$msg" | sed -re "s/\*([^\*]+)\*/\\${esc_strong}\1\\${esc_start}/g" | sed -re "s/_([^_]+)_/\\${esc_em}\1\\${esc_start}/g")"

	printf "%b" "${esc_start}${fmsg}${ESC_RESET}"
}


ask () {
	local msg="$1"
	local default="$2"
	
	local coul="$ESC_RESET"
	local em_coul="$ESC_BY"
	formatted_print "$msg" "$coul" "$coul" "$em_coul"
	printf " %b : " "${ESC_BC}[${ESC_BY}${default}${ESC_BC}]${ESC_RESET}"

	read ask_result
	
	if [ -z "$ask_result" ]
	then
		ask_result="$default"
	fi
}

ask_bool () {
	local msg="$1"
	local default="$2"

	ask "$1" "$default"
	
	case "$ask_result" in
		y|Y|o|O)
			ask_result=y
			;;
		n|N)
			ask_result=n
			;;
		*)
			ask_result="$default"
			;;
	esac
}

step () {
	local msg="$1"

	formatted_print "$msg" "$ESC_BW" "$ESC_BC" "$ESC_BY"
	echo
}

step_info () {
	local msg="$1"
	
	formatted_print " ==> $msg" "$ESC_G" "$ESC_Y" "$ESC_Y"
	echo
}

add_compose_file () {
	local additional_cf="$1"

	step_info "Added compose file : *$additional_cf*"
	conf_compose_files="$conf_compose_files:$additional_cf"
}



printf "\n%b\n" "\t${ESC_BW}Config generation tool${ESC_RESET}"
printf "%b\n\n" "\tPress enter to leave the defaults. Default are in ${ESC_BC}[${ESC_BY}brackets${ESC_BC}]${ESC_RESET}"


env_path=./.env
m2_mount_volume=volume


if [ -e "$env_path" ]
then
	ask_bool "*$env_path* exists, overwrite ?" n
	if [ "$ask_result" = n ]
	then
		exit 0
	fi
	echo
fi

conf_compose_project_name=m2std
conf_compose_files=docker-compose.yml

conf_m2_mount_dir=./magento

conf_m2_root_dir=/var/www/magento
conf_m2_pub_url="http://127.0.0.1"
conf_m2_pub_url_port=

conf_mailhog_pub_web_port=

ask_bool "Web servers accessed directly ? (no proxy of any kind ?)" y
if [ "$ask_result" = y ]
then
	add_compose_file docker-compose.direct-web.yml
	echo

	ask "Magento web container port ?" 80
	conf_m2_pub_url_port="$ask_result"
	echo

	if [ "$conf_m2_pub_url_port" != 80 ]
	then
		conf_m2_pub_url="$conf_m2_pub_url:$conf_m2_pub_url_port"
	fi
	conf_m2_pub_url="$conf_m2_pub_url/"
	
	ask "Mailhog container port ?" 8085
	conf_mailhog_pub_web_port="$ask_result"
	step_info "Mailhog url: *http://localhost:$conf_mailhog_pub_web_port/*"
	echo
else
        step_info "Add docker compose files manually"
	echo
fi

ask "Magento base url ?" "$conf_m2_pub_url"
conf_m2_pub_url="$ask_result"
step_info "Base url: *$conf_m2_pub_url*"
echo

ask_bool "Need local access to Magento files ?" y
if [ "$ask_result" = y ]
then
	add_compose_file docker-compose.m2-web-mount.yml
	if [ ! -e "$conf_m2_mount_dir" ]
	then
		step_info "Creating *$conf_m2_mount_dir*"
		mkdir "$conf_m2_mount_dir"
	fi
	step_info "Will mount Magento root to *$conf_m2_mount_dir*"
else
	add_compose_file docker-compose.m2-web-volume.yml
	step_info "will mount Magento root as a docker volume *${conf_compose_project_name}_${m2_mount_volume}*"
fi
echo

ask_bool "Magento EE ?" y
conf_m2_ee="$ask_result"
echo
echo


compose_override_file=./docker-compose.override.yml
step "Processing *$compose_override_file* ..."
if [ ! -e "$compose_override_file" ]
then
	step_info "Creating *$compose_override_file*"
	echo "version: '3'" > "$compose_override_file"
fi
add_compose_file docker-compose.override.yml
echo



step "Generating *$env_path* ..."
echo

echo "COMPOSE_PROJECT_NAME=$conf_compose_project_name" > "$env_path"
echo "COMPOSE_FILE=$conf_compose_files" >> "$env_path"

echo "HOST_USER_ID=$(id -u)" >> "$env_path"
echo "HOST_USER_GROUP_ID=$(id -g)" >> "$env_path"

echo "M2_MOUNT_DIR=$conf_m2_mount_dir" >> "$env_path"

echo "M2_ROOT_DIR=$conf_m2_root_dir" >> "$env_path"
echo "M2_PUB_URL_PORT=$conf_m2_pub_url_port" >> "$env_path"
echo "M2_PUB_URL=$conf_m2_pub_url" >> "$env_path"
echo "M2_EE=$conf_m2_ee" >> "$env_path"

echo "MAILHOG_PUB_WEB_PORT=$conf_mailhog_pub_web_port" >> "$env_path"

cat "$env_path"


