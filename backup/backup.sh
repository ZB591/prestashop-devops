#!/bin/bash

BACKUP_DIR="/backups"
MAX_BACKUPS=5
DATE=$(date +%Y%m%d_%H%M%S)
FILENAME="$BACKUP_DIR/mysql_backup_$DATE.sql.gz"

echo "🔄 Démarrage du backup : $DATE"

# Dump MySQL compressé
mysqldump -h mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" | gzip > "$FILENAME"

if [ $? -eq 0 ]; then
    echo "✅ Backup réussi : $FILENAME"
else
    echo "❌ Erreur lors du backup !"
    exit 1
fi

# Rotation : supprimer les anciens backups
BACKUP_COUNT=$(ls -1 $BACKUP_DIR/*.sql.gz 2>/dev/null | wc -l)
if [ "$BACKUP_COUNT" -gt "$MAX_BACKUPS" ]; then
    ls -1t $BACKUP_DIR/*.sql.gz | tail -n +$((MAX_BACKUPS + 1)) | xargs rm -f
    echo "🗑️ Anciens backups supprimés (max: $MAX_BACKUPS)"
fi

# Attendre 6h avant le prochain backup
echo "⏳ Prochain backup dans 6h..."
sleep 21600