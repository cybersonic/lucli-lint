<cfcomponent>
    
    <cffunction name="processData" access="public" returntype="string">
        <cfargument name="data" type="string" required="true">
        
        <!--- Variables without VAR declarations --->
        result = "";
        i = 1;
        
        <cfset temp = "temporary variable">
        <cfset x = "short name">
        <cfdump var="#arguments.data#">
        
        <!--- SQL without cfqueryparam --->
        <cfquery name="qryUsers" datasource="mydb">
            SELECT * FROM users 
            WHERE status = '#arguments.data#'
        </cfquery>
        
        <!--- Global variable usage --->
        <cfset session.userData = arguments.data>
        
        <!--- Using createObject --->
        <cfset myComponent = createObject("component", "MyComponent")>
        
        <cfabort>
        
        <cfreturn result>
    </cffunction>
    
    <!--- Function without hint --->
    <cffunction name="anotherFunction">
        <cfset localVar = "test">
        <cfreturn localVar>
    </cffunction>
    
    <!--- Very long function that exceeds 100 lines --->
    <cffunction name="veryLongFunction" hint="This is a very long function">
        <cfset var step1 = "">
        <cfset var step2 = "">
        <cfset var step3 = "">
        <cfset var step4 = "">
        <cfset var step5 = "">
        <cfset var step6 = "">
        <cfset var step7 = "">
        <cfset var step8 = "">
        <cfset var step9 = "">
        <cfset var step10 = "">
        <cfset var step11 = "">
        <cfset var step12 = "">
        <cfset var step13 = "">
        <cfset var step14 = "">
        <cfset var step15 = "">
        <cfset var step16 = "">
        <cfset var step17 = "">
        <cfset var step18 = "">
        <cfset var step19 = "">
        <cfset var step20 = "">
        <cfset var step21 = "">
        <cfset var step22 = "">
        <cfset var step23 = "">
        <cfset var step24 = "">
        <cfset var step25 = "">
        <cfset var step26 = "">
        <cfset var step27 = "">
        <cfset var step28 = "">
        <cfset var step29 = "">
        <cfset var step30 = "">
        <cfset var step31 = "">
        <cfset var step32 = "">
        <cfset var step33 = "">
        <cfset var step34 = "">
        <cfset var step35 = "">
        <cfset var step36 = "">
        <cfset var step37 = "">
        <cfset var step38 = "">
        <cfset var step39 = "">
        <cfset var step40 = "">
        <cfset var step41 = "">
        <cfset var step42 = "">
        <cfset var step43 = "">
        <cfset var step44 = "">
        <cfset var step45 = "">
        <cfset var step46 = "">
        <cfset var step47 = "">
        <cfset var step48 = "">
        <cfset var step49 = "">
        <cfset var step50 = "">
        <cfset var step51 = "">
        <cfset var step52 = "">
        <cfset var step53 = "">
        <cfset var step54 = "">
        <cfset var step55 = "">
        <cfset var step56 = "">
        <cfset var step57 = "">
        <cfset var step58 = "">
        <cfset var step59 = "">
        <cfset var step60 = "">
        <cfset var step61 = "">
        <cfset var step62 = "">
        <cfset var step63 = "">
        <cfset var step64 = "">
        <cfset var step65 = "">
        <cfset var step66 = "">
        <cfset var step67 = "">
        <cfset var step68 = "">
        <cfset var step69 = "">
        <cfset var step70 = "">
        <cfset var step71 = "">
        <cfset var step72 = "">
        <cfset var step73 = "">
        <cfset var step74 = "">
        <cfset var step75 = "">
        <cfset var step76 = "">
        <cfset var step77 = "">
        <cfset var step78 = "">
        <cfset var step79 = "">
        <cfset var step80 = "">
        <cfset var step81 = "">
        <cfset var step82 = "">
        <cfset var step83 = "">
        <cfset var step84 = "">
        <cfset var step85 = "">
        <cfset var step86 = "">
        <cfset var step87 = "">
        <cfset var step88 = "">
        <cfset var step89 = "">
        <cfset var step90 = "">
        <cfset var step91 = "">
        <cfset var step92 = "">
        <cfset var step93 = "">
        <cfset var step94 = "">
        <cfset var step95 = "">
        <cfset var step96 = "">
        <cfset var step97 = "">
        <cfset var step98 = "">
        <cfset var step99 = "">
        <cfset var step100 = "">
        <cfset var step101 = "">
        <cfset var step102 = "">
        
        <cfreturn "done">
    </cffunction>
    
</cfcomponent>
