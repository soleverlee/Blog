hexo clean && hexo generate && cd public
rsync -avz --delete . root@riguz.com:/home/www/static
