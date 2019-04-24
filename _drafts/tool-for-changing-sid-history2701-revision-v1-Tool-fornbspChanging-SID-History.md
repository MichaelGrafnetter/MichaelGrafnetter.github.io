---
id: 8361
title: 'Tool for&nbsp;Changing SID History'
date: 2016-11-27T12:08:53+00:00
author: Michael Grafnetter
layout: revision
guid: https://www.dsinternals.com/2701-revision-v1/
permalink: /2701-revision-v1/
---
<p style="text-align: justify;">
  One of&nbsp;the possible attacks on Active Directory security is&nbsp;forging the <a title="SID History" href="https://blog.thesysadmins.co.uk/admt-series-3-sid-history.html">SID History</a>. People at Microsoft are of&nbsp;course fully aware of&nbsp;this threat and&nbsp;they have implemented 2 mechanisms in Active Directory that&nbsp;hinder the&nbsp;feasibility of&nbsp;this type of&nbsp;attack:
</p>

<li style="text-align: justify;">
  Values of&nbsp;the sIDHistory attribute coming from&nbsp;external trusts are ignored due to&nbsp;the <a title="Configuring SID Filtering Settings" href="https://technet.microsoft.com/en-us/library/cc772633%28v=ws.10%29.aspx">SID Filtering</a> feature, which&nbsp;is&nbsp;on by&nbsp;default.
</li>
<li style="text-align: justify;">
  The&nbsp;sIDHistory cannot be changed to&nbsp;an arbitrary value, neither through the Active Directory Users and&nbsp;Computers console, nor&nbsp;through PowerShell or some API. The&nbsp;only supported way is&nbsp;using the <a title="Active Directory Migration Tool" href="https://technet.microsoft.com/en-us/library/cc974332%28v=ws.10%29.aspx">ADMT</a>, that&nbsp;can copy an existing SID from&nbsp;a&nbsp;trusted domain to SID History a trusting domain.
</li>

<p style="text-align: justify;">
  But&nbsp;is&nbsp;it possible to&nbsp;write any value to&nbsp;the SID History and&nbsp;thus circumvent one of&nbsp;the security features mentioned above? YES! <!--more-->
</p>

### Existing Solutions

There are several tools available that&nbsp;can be used to&nbsp;change the&nbsp;SID History:

<ol type="A">
  <li>
    Using a&nbsp;Samba 4 DC <ul>
      <li>
        Process: <ol>
          <li>
            Add a Samba 4 domain controller to&nbsp;the Active Directory domain.
          </li>
          <li>
            <a href="http://cosmoskey.blogspot.cz/2010/08/online-sidhistory-edit-sid-injection.html">Manually edit</a> the&nbsp;SID History in&nbsp;its LDAP database.
          </li>
          <li>
            Replicate this change to a Windows Server DC.
          </li>
          <li>
            Demote the&nbsp;Samba 4 DC.
          </li>
        </ol>
      </li>
      
      <li>
        Cons: <ul>
          <li style="text-align: justify;">
            Addition of&nbsp;a new DC is not performed on a&nbsp;daily basis and probably won&#8217;t stay unnoticed.
          </li>
          <li style="text-align: justify;">
            Because&nbsp;of&nbsp;a few bugs in&nbsp;Samba 4, the&nbsp;replication with Windows Server DCs will not always work correctly. There is&nbsp;even a risk of corrupting the&nbsp;AD database and such risks cannot be taken in&nbsp;production environments.
          </li>
        </ul>
      </li>
    </ul>
  </li>
  
  <li>
    Offline modification of&nbsp;the database <ul>
      <li>
        Process: <ol>
          <li>
            Stop the Active ntds service.
          </li>
          <li style="text-align: justify;">
            Write the&nbsp;sIDHistory attribute directly to&nbsp;the ntds.dit file using a&nbsp;tool like <a title="SHEdit" href="http://www.tbiro.com/projects/SHEdit/">SHEdit</a> or <a title="Безопасность в Active Directory " href="http://gexeg.blogspot.cz/2009/12/active-directory.html">ESEAddSidHistory</a>.
          </li>
          <li>
            Perform <a href="https://technet.microsoft.com/en-us/library/cc940334.aspx">authoritative restore</a> of&nbsp;the affected objects.
          </li>
          <li>
            Start the&nbsp;ntds service again and&nbsp;keep your fingers crossed.
          </li>
        </ol>
      </li>
      
      <li>
        Cons: <ul>
          <li>
            These tools can find the&nbsp;user account only by&nbsp;GUID, but&nbsp;not by&nbsp;login or&nbsp;distinguished name.
          </li>
          <li>
            SHEdit only supports Windows Server 2003.
          </li>
          <li>
            They cannot write multiple values to&nbsp;the SID History.
          </li>
          <li>
            They won&#8217;t update the&nbsp;replication metadata.
          </li>
          <li>
            The SID History attribute value has to&nbsp;be provided&nbsp;in&nbsp;its binary representation.
          </li>
          <li>
            These tools do&nbsp;not use the&nbsp;associated transaction log.
          </li>
          <li>
            The&nbsp;database might get corrupted by&nbsp;these tools.
          </li>
        </ul>
      </li>
    </ul>
  </li>
  
  <li>
    <a href="https://github.com/gentilkiwi/mimikatz">Mimikatz</a> <ol>
      <li>
        Well, mimikatz is&nbsp;the usual suspect for&nbsp;doing anything evil to&nbsp;Windows security.
      </li>
      <li>
        Process:
      </li>
      <li>
        Just type the&nbsp;following command: <ul>
          <li>
            <pre class="lang:batch decode:true ">mimikatz "privilege::debug" "misc::addsid hacker Administrator"</pre>
            
            <p>
              &nbsp;</li> </ul> </li> </ol> </li> </ol> 
              
              <h3>
                My Solution
              </h3>
              
              <p>
                Because all of&nbsp;these solutions have serious drawbacks, I&nbsp;created my own tool, the&nbsp;Add-ADDBSidHistory PowerShell cmdlet, that&nbsp;alsoktorý tiež robí offline modifikáciu databázy a&nbsp;má tieto vlastnosti:
              </p>
              
              <ul>
                <li>
                  Je&nbsp;spravený ako PowerShell 3+ príkaz and&nbsp;supports pipeline input.
                </li>
                <li>
                  Security principals (users, computers and&nbsp;groups) vie vyhľadať na&nbsp;základe atribútov objectSid, objectGUID, sAMAccountName a&nbsp;distinguishedName. Pri vyhľadávaní na&nbsp;základe sAMAccountName odfiltruje zmazané a&nbsp;read-only objekty (kvôli GC). Ďalej využíva indexy, takže pracuje rýchlo aj&nbsp;nad databázou so&nbsp;150K+ objektami.
                </li>
                <li>
                  Nové hodnoty SID History sú pridané k&nbsp;existujúcim, ak nie sú duplicitné.
                </li>
                <li>
                  Upraví replikačné metadáta (atribúty uSNChanged, whenChanged, replPropertyMetaData a&nbsp;globálny čítač HighestCommittedUsn). Toto východzie chovanie sa&nbsp;dá zmeniť pomocou prepínača -SkipMetaUpdate.
                </li>
                <li>
                  Umožňuje zadať cestu k&nbsp;tranzakčným logom, pokiaľ nie sú uložené v&nbsp;databázovom adresári.
                </li>
                <li>
                  Vie sa&nbsp;zotaviť z&nbsp;chybových stavov vďaka využitiu tranzakcií.
                </li>
                <li>
                  The&nbsp;command works on Windows Server 2012 R2 and&nbsp;2008 R2.
                </li>
              </ul>
              
              <p>
                Example of&nbsp;use:
              </p>
              
              <pre title="SID History" class="lang:ps decode:true">Import-Module .\DSInternals
Stop-Service ntds -Force
Add-ADDBSidHistory -SamAccountName April -SidHistory 'S-1-5-21-1868298443-3554975232-1738066521-500' -DBPath 'C:\Windows\NTDS\ntds.dit'
Start-Service ntds</pre>
              
              <p>
                The&nbsp;result might then look like this:
              </p>
              
              <p>
                <img class="aligncenter size-full wp-image-2541" src="https://www.dsinternals.com/wp-content/uploads/sid_history.png" alt="Sid History" width="425" height="563" srcset="https://www.dsinternals.com/wp-content/uploads/sid_history.png 425w, https://www.dsinternals.com/wp-content/uploads/sid_history-226x300.png 226w" sizes="(max-width: 425px) 100vw, 425px" />
              </p>
              
              <p>
                As&nbsp;always, the&nbsp;Add-ADDBSidHistory cmdlet is&nbsp;part of&nbsp;the <a href="https://www.dsinternals.com/en/downloads/">DSInternals PowerShell module</a>.
              </p>
              
              <p>
                <strong>WARNING:</strong> Always perform a&nbsp;backup of&nbsp;the database and&nbsp;transaction logs before&nbsp;running this command.
              </p>