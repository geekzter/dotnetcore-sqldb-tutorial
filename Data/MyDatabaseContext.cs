using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace DotNetCoreSqlDb.Models
{
    public class MyDatabaseContext : DbContext
    {
        public MyDatabaseContext (DbContextOptions<MyDatabaseContext> options)
            : base(options)
        {
            var conn = Database.GetDbConnection() as Microsoft.Data.SqlClient.SqlConnection;
            if (conn != null) {
                Microsoft.Azure.Services.AppAuthentication.AzureServiceTokenProvider tokenProvider = new Microsoft.Azure.Services.AppAuthentication.AzureServiceTokenProvider();

                // Get AAD token when using SQL Database
                conn.AccessToken = tokenProvider.GetAccessTokenAsync("https://database.windows.net/").Result;
            }
        }

        public DbSet<DotNetCoreSqlDb.Models.Todo> Todo { get; set; }
    }
}
