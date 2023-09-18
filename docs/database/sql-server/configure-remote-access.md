# Configure remote access

## TOC

1. [Allowing Remote Connections](#allowing-remote-connections)
2. [Add Remote User to the database](#add-a-remote-user-to-the-database)
3. [Configuring the SQL Server Instance](#configuring-the-sql-server-instance)
4. [Configuring Windows Firewall](#configuring-windows-firewall)
5. [Fetch the Connection Details](#fetch-the-connection-details)
6. [Connecting to the remote machine](#connecting-to-the-remote-machine)


## Allowing Remote Connections

1. Right-click the on the SQL Server instance name and select Properties.
2. Select Connections on the left-hand pane.
3. Under Remote Server Connections, check the box against "Allow remote connections to this server".

## Add a Remote User to the database

1. In SQL Server Management Studio (SSMS) Object Explorer, right-click the server, and then select Properties.
2. On the Security page, under Server authentication, select the **SQL Server and Windows Authentication mode**, and then select OK.
3. In the SQL Server Management Studio dialog box, select OK to acknowledge the requirement to restart SQL Server.
4. In Object Explorer, right-click your server, and then select Restart. If SQL Server Agent is running, it must also be restarted.
5. Use Transact-SQL to enable sa login

```sql
ALTER LOGIN sa ENABLE;
GO
ALTER LOGIN sa WITH PASSWORD = '<enterStrongPasswordHere>';
GO
```

## Configuring the SQL Server Instance

1. Select SQL Server Configuration Manager from the Start.
2. Navigate to Protocols for `YOUR SERVER NAME` under SQL Server Network Configuration on the left-hand pane.
3. Make sure that the TCP/IP Protocol Name is Enabled.
4. Right-click on TCP/IP Protocol Name and select the Property option.
5. Navigate to the IP Addresses tab and scroll down to the section named "IPAII".
6. If the TCP Dynamic Ports is set to 0 (indicates the Database Engine is listening on dynamic ports), then remove the 0 and set it to blank.
7. Update the value for TCP Port to 1433. This is the default port that is being used by the SQL Server Database Engine and click OK.
8. A warning might be displayed which will prompt to restart the service.

### Configuring Windows Firewall

Use PowerShell to open TCP port 1433 and UDP port 1434 for SQL Server default instance, and SQL Server Browser Service: 

``` bash
New-NetFirewallRule -DisplayName "SQLServer default instance" -Direction Inbound -LocalPort 1433 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "SQLServer Browser service" -Direction Inbound -LocalPort 1434 -Protocol UDP -Action Allow
```

## Fetch the Connection Details

1. Open Command Prompt and type ipconfig.
2. Copy the IPv4 Address.

```bash
ipconfig
```

## Connecting to the remote machine

1. Open SQL Server Management Studio.
2. Provide the Server name with the `<REMOTE MACHINE IP>`.
