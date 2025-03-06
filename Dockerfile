FROM nginx:latest
ENV path=/usr/share/nginx
COPY index.html $path/html
COPY inner-page.html $path/html
COPY portfolio-details.html $path/html
COPY assets $path/html/assets
COPY forms $path/html/forms
WORKDIR $path/html
CMD ["nginx", "-g", "daemon off;"]
