#!/bin/bash

# Change to Nextcloud directory
cd /var/www/html

echo "Disabling logreader app..."

# Disable the logreader app
php occ app:disable logreader 2>/dev/null || echo "Failed to disable logreader app (might already be disabled)"

# Disable the logreader app
php occ app:disable serverinfo 2>/dev/null || echo "Failed to disable serverinfo app (might already be disabled)"

echo "Apps disabled"
