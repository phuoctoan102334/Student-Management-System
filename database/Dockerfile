FROM mcr.microsoft.com/mssql/server:2022-latest
USER root
COPY database-setup.sql /opt/mssql-init/database-setup.sql
COPY entrypoint-init.sh /opt/mssql-init/entrypoint-init.sh
RUN chmod +x /opt/mssql-init/entrypoint-init.sh
USER mssql
ENTRYPOINT ["/opt/mssql-init/entrypoint-init.sh"]
