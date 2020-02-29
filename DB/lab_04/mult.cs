// 2) Пользовательскую агрегатную функцию CLR,
using System;  
using System.Data;  
using System.Data.SqlClient;  
using System.Data.SqlTypes;  
using Microsoft.SqlServer.Server;  
  
[Serializable]  
[SqlUserDefinedAggregate(  
    Format.Native,  
    IsInvariantToDuplicates = false,  
    IsInvariantToNulls = true,  
    IsInvariantToOrder = true,  
    IsNullIfEmpty = true,  
    Name = "Mult")]

public struct Mult  
{  
    private long mul;  
    
    // инициализация аккумулятора
    public void Init()
    {
        mul = 1;
    }
    
    // изменение аккумулятора
    public void Accumulate(SqlInt32 Value)  
    {  
        if (!Value.IsNull)  
        {  
            mul *= (long)Value;
        }  
    }  
    
    // операция для групп
    public void Merge(Mult Group)  
    {  
        mul *= Group.mul; 
    }
    
    // завершение вычислений
    public SqlInt32 Terminate()  
    {  
 
        int value = (int)mul;
        return new SqlInt32(value);  

    }  
}  