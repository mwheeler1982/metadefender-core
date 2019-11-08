FROM mcr.microsoft.com/windows/servercore:ltsc2019

ARG vcredist_file
ARG ometascan_install_file
ARG version

# Expose port
EXPOSE 8008/tcp
EXPOSE 8007/tcp

# Copy over required files
COPY src/* /OPSWAT/

# Set Powershell as our shell
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Download VCRedist File
RUN Invoke-WebRequest -Uri https://aka.ms/vs/16/release/vc_redist.x64.exe -Outfile C:\\OPSWAT\\$env:vcredist_file

# Install applications
# VCRedist
RUN Start-Process -Wait -Filepath C:\\OPSWAT\\$env:vcredist_file -ArgumentList "/install", "/passive", "/norestart" ;

# Download Core Installer
RUN Invoke-WebRequest -Uri https://metascanbucket.s3.amazonaws.com/Metadefender/Core/v4/$env:version/windows/$env:ometascan_install_file -Outfile C:\\OPSWAT\\$env:ometascan_install_file

# MetaDefender Core Installer
RUN Start-Process msiexec.exe -Wait -ArgumentList "/i", "C:\\OPSWAT\\$env:ometascan_install_file", "/qn", "/norestart" ;

# Define entrypoint
ENTRYPOINT ["powershell.exe", "C:\\OPSWAT\\start.ps1"]