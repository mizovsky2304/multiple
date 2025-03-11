#!/bin/bash

# Color and icon definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
RESET='\033[0m'
ICON_TELEGRAM="🚀"
ICON_INSTALL="🛠️"
ICON_LOGS="📄"
ICON_RESTART="🔄"
ICON_STOP="⏹️"
ICON_START="▶️"
ICON_EXIT="❌"
ICON_REMOVE="🗑️"
ICON_VIEW="👀"





# Global variables
PROJCET_NAME="Multiple Network"
PROJECT_DIR="$HOME/multiple"
ENV_FILE="$PROJECT_DIR/multipleforlinux/.env"
LOGFILE="$PROJECT_DIR/multipleforlinux/logs/multiple.log"
NODE_PM2_NAME="multiple"

# Draw menu borders and telegram icon
draw_top_border() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════════╗${RESET}"
}
draw_middle_border() {
    echo -e "${CYAN}╠══════════════════════════════════════════════════════════════════════════╣${RESET}"
}
draw_bottom_border() {
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════════╝${RESET}"
}
print_telegram_icon() {
    echo -e "          ${MAGENTA}${ICON_TELEGRAM} Follow us on Telegram!${RESET}"
}
display_ascii() {
    echo -e "${RED}    ____                  _          ____      _            _  _         ${RESET}"    
    echo -e "${GREEN}   / ___|_ __ _   _ _ __ | |_ ___   | __ )  __| | __ _ _ __(_)(_) __ _   ${RESET}" 
    echo -e "${BLUE}  | |   | '__| | | | '_ \\| __/ _ \\  |  _ \\ / _\` |/ _\` | '__| || |/ _\` |  ${RESET}"
    echo -e "${YELLOW}  | |___| |  | |_| | |_) | || (_) | | |_) | (_| | (_| | |  | || | (_| |  ${RESET}"
    echo -e "${MAGENTA}   \\____|_|   \\__, | .__/ \\__\\___/  |____/ \\__,_|\\__,_|_|  |_|/ |\\__,_|  ${RESET}"
    echo -e "${RED}              |___/|_|                                      |__/        ${RESET}"       
}





# Display main menu
show_menu() {
    clear
    draw_top_border
    display_ascii
    draw_middle_border
    print_telegram_icon
    echo -e "    ${BLUE}Subscribe to our channel: ${YELLOW}https://discord.gg/uJEeSe9E${RESET}"
    draw_middle_border
    echo -e "                ${GREEN}Node Manager for ${PROJCET_NAME}${RESET}"
    echo 
    echo -e "    ${YELLOW}Please choose an option:${RESET}"
    echo -e "    ${CYAN}1.${RESET} ${ICON_INSTALL}  Install Node"
    echo -e "    ${CYAN}2.${RESET} ${ICON_LOGS} View Logs"
    echo -e "    ${CYAN}3.${RESET} ${ICON_RESTART} Restart Node"
    echo -e "    ${CYAN}4.${RESET} ${ICON_STOP}  Stop Node"
    echo -e "    ${CYAN}5.${RESET} ${ICON_REMOVE}   Remove Node"
    echo -e "    ${CYAN}6.${RESET} ${ICON_START}  Start Node"
    
    
    
    echo -e "    ${CYAN}0.${RESET} ${ICON_EXIT} Exit"
    draw_bottom_border
    echo -ne "${YELLOW}Enter a command number [0-6]:${RESET} "
    read choice
}


# Install node function with registration link and check
install_node() {
    
    echo 
    echo 
    echo -e "${YELLOW}To continue, please register at the following link:${RESET}"
    echo -e "${CYAN}https://www.app.multiple.cc/#/signup?inviteCode=V6HSL3ru${RESET}"
    
    echo 
    echo 
    echo -ne "${YELLOW}Have you completed registration? (y/n): ${RESET}"
    read registered

    if [[ "$registered" != "y" && "$registered" != "Y" ]]; then
        echo -e "${RED}Please complete the registration and use referral code V6HSL3ru to continue.${RESET}"
        read -p "Press Enter to return to the menu..."
        return
    fi
    

    
    echo 
    echo 
    echo
    echo -e "${GREEN}🛠️  Installing node...${RESET}"
    sudo apt -q update
    cd $HOME
    

    echo
    # Create Project Folder
    if [ ! -d "$PROJECT_DIR" ]; then
        mkdir -p "$PROJECT_DIR"
        cd "$PROJECT_DIR"
        echo -e "${CYAN}🗂️  Folder $PROJECT_DIR created.${RESET}"
    else
        echo -e "${RED}🗂️  Folder $PROJECT_DIR already exist.${RESET}"
        rm -fr $PROJECT_DIR/multipleforlinux
        rm -fr $PROJECT_DIR/multipleforlinux.tar
    fi
    echo 

    cd "$PROJECT_DIR"
      
    #Check & Install dotenv
    echo
    if npm list dotenv >/dev/null 2>&1; then
      echo -e "${GREEN}⚙️  dotenv is already installed${RESET}"
    else
      echo -e "${RED}⚙️  dotenv is not installed${RESET}"
        echo -e "${GREEN}🛠️  Installing dotenv...${RESET}"
      npm install dotenv
      if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ dotenv successfully installed${RESET}"
      else
        echo -e "${RED}❌ Failed to install dotenv${RESET}"
        exit 1
      fi
    fi
    echo


    # Check & Install pm2
    echo
    if ! command -v pm2 &> /dev/null; then
      echo -e "${RED}⚙️  pm2 is not installed. Processing installation${RESET}"
      npm install -g pm2
    else
      echo -e "${GREEN}⚙️  pm2 already installed.${RESET}"
      pm2 stop $NODE_PM2_NAME
      pm2 delete $NODE_PM2_NAME
    fi
    echo



    # 🖥️ Check Linux architecture
    echo
    echo -e "${YELLOW}🖥️  Checking Linux architecture ${RESET}"
    ARCH=$(uname -m)
    if [[ "$ARCH" == "x86_64" ]]; then
        CLIENT_URL="https://mdeck-download.s3.us-east-1.amazonaws.com/client/linux/x64/multipleforlinux.tar"
    elif [[ "$ARCH" == "aarch64" ]]; then
        CLIENT_URL="https://mdeck-download.s3.us-east-1.amazonaws.com/client/linux/arm64/multipleforlinux.tar"
    else
        echo -e "${RED}❌ Architecture not supported: $ARCH${RESET}"
        exit 1
    fi
    echo
    echo -e "${GREEN}✅ Download link for '$ARCH' architecture generated succefully  ${RESET}"
    
    echo
    echo -e "${CYAN}⬇️   Downloading client from $CLIENT_URL... ${RESET}"
    wget $CLIENT_URL -O multipleforlinux.tar
    echo

    echo -e "${YELLOW}📦 Extracting installation package...${RESET}";
    tar -xvf multipleforlinux.tar
    echo

    # Check if extraction was successful
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅  Extraction successful.${RESET}"
    else
        echo -e "${RED}❌  Extraction failed, please check the multipleforlinux.tar file.${RESET}"
        exit 1
    fi
    echo



    # Check if the extracted files contain 'executor'
    echo
    echo -e "${YELLOW}🚦  Checking if the extracted files or directories contain 'multipleforlinux' folder ...${RESET}"
    
    if ls | grep -q 'multipleforlinux'; then
        echo
        echo -e "${GREEN}✅  Check passed, found folder or directories containing 'multipleforlinux'.${RESET}"
    else
        echo
        echo -e "${RED}❌  No files or directories containing 'multipleforlinux' were found, possibly incorrect file name.${RESET}"
        exit 1
    fi
    echo


    # Entering the extracted directory
    echo -e "${YELLOW}🗂️  Entering the extracted directory...${RESET}"
    chmod -R 777 multipleforlinux
    cd multipleforlinux
    echo ""

    # Grant permissions
    echo -e "${YELLOW}🔧 Setting required permissions...${RESET}"
    chmod +x multiple-cli
    chmod +x multiple-node
    echo ""


    # Add PATH to .bashrc
    echo -e "${LIGHT_BLUE}⚙️  Configuring PATH...${RESET}"
    echo "PATH=\$PATH:$(pwd)" >> ~/.bashrc
    source ~/.bashrc
    echo ""


    # Create logs folder if it doesn't exist
    if [ ! -d "logs" ]; then
        echo -e "${CYAN}📂 Creating logs folder...${RESET}"
        mkdir -p logs
    fi

    echo ""
    # Check if the .env file exists
    if [ -f "$ENV_FILE" ]; then
        echo
        echo -e "${GREEN}✅ $ENV_FILE found.${RESET}"
        
        # Load environment variables from the file
        source "$ENV_FILE"
        
        # Check if the IDENTIFIER variable is set
        if [ -n "$IDENTIFIER" ]; then
            echo -e "${GREEN}👮‍♀️ IDENTIFIER is already set in $ENV_FILE.${RESET}"
        else
            echo -e "${RED}❌ IDENTIFIER variable is not set in $ENV_FILE!${RESET}"
        fi

        # Check if the PIN variable is set
        if [ -n "$PIN" ]; then
            echo -e "${GREEN}🔑 PIN is already set in $ENV_FILE.${RESET}"
        else
            echo -e "${RED}❌ PIN variable is not set in $ENV_FILE!${RESET}"
        fi

    else
        # .env file not found
        echo -e "${RED}❌ $ENV_FILE not found! Creating it now...${RESET}"
        echo
        
        # Prompt for the IDENTIFIER
        read -p "Enter your IDENTIFIER: " IDENTIFIER
        while [ -z "$IDENTIFIER" ]; do
            echo -e "${RED}❌ IDENTIFIER cannot be empty!${RESET}"
            read -sp "Enter your IDENTIFIER: " IDENTIFIER
        done

        # Prompt for the PIN
        read -p "Enter your PIN: " PIN
        while [ -z "$PIN" ]; do
            echo -e "${RED}❌ PIN cannot be empty!${RESET}"
            read -sp "Enter your PIN: " PIN
        done

        # Create the .env file and write the variables
        {
            echo "IDENTIFIER=$IDENTIFIER"
            echo "PIN=$PIN"
        } > "$ENV_FILE"

        # Load the newly created variables
        source "$ENV_FILE"
        echo -e "${GREEN}✅ IDENTIFIER and PIN variables have been set in $ENV_FILE.${RESET}"
    fi

    echo

    # Validate the IDENTIFIER and PIN variables
    if [ -z "$IDENTIFIER" ] || [ -z "$PIN" ]; then
        echo -e "${RED}❌ ERROR: IDENTIFIER and PIN cannot be empty.${RESET}"
        exit 1
    else
        echo -e "${GREEN}✅ IDENTIFIER and PIN are valid.${RESET}"
    fi


    # Run multiple-node
    echo ""
    echo -e "${YELLOW}🚀 Running multiple-node...${RESET}"
    echo 
    pm2 start ./multiple-node --name "$NODE_PM2_NAME" --log "$LOGFILE"
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to start multiple-node using PM2. Check your configuration.${RESET}"
        exit 1
    fi
    
    # Save PM2 process list
    echo
    pm2 save
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to save PM2 process list. Check permissions.${RESET}"
        exit 1
    fi

    # Enable PM2 startup on boot
    pm2 startup
    echo
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to configure PM2 startup. Check your PM2 installation.${RESET}"
        exit 1
    fi

    # Wait a few seconds to allow the process to initialize
    echo -e "${YELLOW}⏳ Waiting for multiple-node to start...${RESET}"
    sleep 3

    # Check if multiple-node is running
    NODE_PID=$(pgrep -f "multiple-node")
    if [[ -n "$NODE_PID" ]]; then
        echo -e "${GREEN}✅ multiple-node is running with PID: $NODE_PID.${RESET}"
    else
        echo -e "${RED}❌ multiple-node is not running. Check logs at $LOGFILE for details.${RESET}"
        exit 1
    fi



    # Bind account with IDENTIFIER and PIN
    echo 
    echo -e "${YELLOW}🔗 Binding account with IDENTIFIER and PIN...${RESET}"
    ./multiple-cli bind --bandwidth-download 100 --identifier "$IDENTIFIER" --pin "$PIN" --storage 200 --bandwidth-upload 100
    echo 

    
    echo -e "${GREEN}✅ Multiple Network node installed successfully. Check the logs to confirm binding.${RESET}"
    
    
    
    echo
    echo
    echo
    read -p "Press Enter to return to the menu..."
}


# View logs function
view_logs() {
    echo

    echo -e "${GREEN}📄 Viewing logs...${RESET}"
    #pm2 logs $NODE_PM2_NAME --lines 50 
    tail -n 50 $LOGFILE
    
    echo
    echo
    read -p "Press Enter to return to the menu..."
}

# Restart node function
restart_node() {
    echo

    echo -e "${GREEN}🔄 Restarting node...${RESET}"
    pm2 restart $NODE_PM2_NAME
    echo -e "${GREEN}✅ Node restarted.${RESET}"
    
    echo
    echo
    read -p "Press Enter to return to the menu..."
}

# Stop node function
stop_node() {
    echo 

    echo -e "${YELLOW}⏹️  Stopping node...${RESET}"
    echo 
    pm2 stop $NODE_PM2_NAME
    echo -e "${GREEN}✅ Node stopped.${RESET}"
    
    echo
    echo
    read -p "Press Enter to return to the menu..."
}

# Start node function
start_node() {
    echo 

    echo -e "${GREEN}▶️ Starting node...${RESET}"
    pm2 start $NODE_PM2_NAME
    echo -e "${GREEN}✅ Node started.${RESET}"
    
    echo
    echo
    read -p "Press Enter to return to the menu..."
}

# Remove node function
remove_node() {
    echo 

    echo -e "${YELLOW}🗑️  Removing node...${RESET}"
    echo
    pm2 delete $NODE_PM2_NAME
    echo
    rm -fr "$PROJECT_DIR/multipleforlinux" "$PROJECT_DIR/multipleforlinux.tar"
    
    echo
    echo -e "${GREEN}✅ Node removed.${RESET}"
    
    
    
    echo
    echo
    read -p "Press Enter to return to the menu..."
}











# Main menu loop
while true; do
    show_menu
    case $choice in
        1)
            install_node
            ;;
        2)
            view_logs
            ;;
        3)
            restart_node
            ;;
        4)
            stop_node
            ;;
        5)
            remove_node
            ;;
        6)
            start_node
            ;;
        
        0)
            echo -e "${GREEN}❌ Exiting...${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Invalid input. Please try again.${RESET}"
            read -p "Press Enter to continue..."
            ;;
    esac
done
