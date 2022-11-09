## 절차
#1. nodejs 설치
#2. app 디렉토리 생성
#3. package*.json파일 app 디렉토리로 복사
#4. npm install
#5. dockerignore에서 등록한 리스트를 제외한 모든 파일 /app으로 복사
#6. vue build - dist파일 생성
#7. nginx 설치
#8. 기존에 있는 nginx 설정 삭제 - default.conf
#9. /app 디렉토리에 옮겨둔 default.conf를 /etc/nginx/conf.d/default.conf로 이동
#10. nginx 설치시 root경로(/usr/share/nginx/html/) 밑 파일 삭제
#11. 6번에서 build한 dist파일을 root 경로로 이동 


FROM node:18.12.1 as build-stage
MAINTAINER asia924@naver.com

# make the folder the current working directory
WORKDIR /app

# copy both 'package.json' and 'package-lock.json' (if available)
COPY package*.json ./

# install project dependencies leaving out dev dependencies
RUN npm install

COPY . .

# build app for production with minification
RUN npm run build



# production stage
FROM nginx:stable-alpine as production-stage
COPY  ./nginx/nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]







# FROM nginx:stable-alpine
# RUN rm-rf /etc/nginx/conf.d/default.conf
# COPY --from=builder /app/nginx/default.conf /etc/nginx/conf.d/default.conf

# RUN rm-rf /usr/share/nginx/html/*
# COPY --from=builder /app/dist /usr/share/nginx/html

# EXPOSE 80
# ENTRYPOINT ["nginx", "-g", "daemon off;"]



