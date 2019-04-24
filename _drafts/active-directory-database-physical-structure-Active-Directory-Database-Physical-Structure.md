---
id: 5061
title: Active Directory Database Physical Structure
date: 2015-09-29T21:32:17+00:00
author: Michael Grafnetter
layout: post
guid: https://www.dsinternals.com/?p=5061
permalink: /en/?p=5061
categories:
  - Uncategorized
---
<pre class="lang:ps decode:true">Get-ADDBSchemaAttribute -DBPath 'C:\IFM\Active Directory\ntds.dit' | where&nbsp;ColumnName -ne $null |
select ColumnName,Name,Index |
ConvertTo-Html |
Out-File schema.html</pre>

<div>
  ATTx, Syntax, Syntax Oid
</div>

<table>
  <tr>
    <th style="text-align: left;">
      X
    </th>
    
    <th style="text-align: left;">
      Attribute Syntax
    </th>
    
    <th style="text-align: left;">
      Syntax OID
    </th>
  </tr>
  
  <tr>
    <td>
      b
    </td>
    
    <td>
      DN
    </td>
    
    <td>
      1
    </td>
  </tr>
  
  <tr>
    <td>
    </td>
    
    <td>
    </td>
    
    <td>
      2
    </td>
  </tr>
  
  <tr>
    <td>
    </td>
    
    <td>
    </td>
    
    <td>
      3
    </td>
  </tr>
  
  <tr>
    <td>
    </td>
    
    <td>
    </td>
    
    <td>
      4
    </td>
  </tr>
  
  <tr>
    <td>
    </td>
    
    <td>
    </td>
    
    <td>
      5
    </td>
  </tr>
  
  <tr>
    <td>
       g
    </td>
    
    <td>
    </td>
    
    <td>
      6
    </td>
  </tr>
  
  <tr>
    <td>
    </td>
    
    <td>
    </td>
    
    <td>
      7
    </td>
  </tr>
  
  <tr>
    <td>
      i
    </td>
    
    <td>
    </td>
    
    <td>
      8
    </td>
  </tr>
  
  <tr>
    <td>
       j
    </td>
    
    <td>
    </td>
    
    <td>
      9
    </td>
  </tr>
  
  <tr>
    <td>
    </td>
    
    <td>
    </td>
    
    <td>
      10
    </td>
  </tr>
  
  <tr>
    <td>
    </td>
    
    <td>
    </td>
    
    <td>
      11
    </td>
  </tr>
  
  <tr>
    <td>
    </td>
    
    <td>
    </td>
    
    <td>
      12
    </td>
  </tr>
  
  <tr>
    <td>
    </td>
    
    <td>
    </td>
    
    <td>
      13
    </td>
  </tr>
  
  <tr>
    <td>
    </td>
    
    <td>
    </td>
    
    <td>
      14
    </td>
  </tr>
  
  <tr>
    <td>
    </td>
    
    <td>
    </td>
    
    <td>
      15
    </td>
  </tr>
  
  <tr>
    <td>
       p
    </td>
    
    <td>
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      q
    </td>
    
    <td>
      Int64
    </td>
    
    <td>
      16
    </td>
  </tr>
  
  <tr>
    <td>
      r
    </td>
    
    <td>
      SID
    </td>
    
    <td>
      17
    </td>
  </tr>
</table>

c Oid 2  
&#8212;&#8212;-d 3 missing  
e CaseIgnoreString 4  
f String 5  
g NimericString 6  
h DNWithBinary 7  
i&nbsp;Bool 8  
j Int 9  
k&nbsp;OctetString 10  
l Time 11  
m UnicodeString 12  
n PresentationAddress 13  
&#8212;&#8212;o 14 missing  
p SecurityDescriptor 15  
q Int64 16  
r SID 17

<!--more-->

&nbsp;

Here is&nbsp;the complete schema from&nbsp;a&nbsp;Windows Server 2012 R2 DC:

<table>
  <tr>
    <th style="text-align: left;">
      Column
    </th>
    
    <th style="text-align: left;">
      Attribute
    </th>
    
    <th style="text-align: left;">
      Index
    </th>
  </tr>
  
  <tr>
    <td>
      ab_cnt_col
    </td>
    
    <td>
      ab_cnt
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      Ancestors_col
    </td>
    
    <td>
      Ancestors
    </td>
    
    <td>
      Ancestors_index
    </td>
  </tr>
  
  <tr>
    <td>
      cnt_col
    </td>
    
    <td>
      cnt
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      DNT_col
    </td>
    
    <td>
      DNT
    </td>
    
    <td>
      DNT_index
    </td>
  </tr>
  
  <tr>
    <td>
      extendedprocesslinks_col
    </td>
    
    <td>
      extendedprocesslinks
    </td>
    
    <td>
      exprocesslinks_index
    </td>
  </tr>
  
  <tr>
    <td>
      IsVisibleInAB
    </td>
    
    <td>
      IsVisibleInAB
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      NCDNT_col
    </td>
    
    <td>
      NCDNT
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      OBJ_col
    </td>
    
    <td>
      OBJ
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      PDNT_col
    </td>
    
    <td>
      PDNT
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      RDNtyp_col
    </td>
    
    <td>
      RDNtyp
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      recycle_time_col
    </td>
    
    <td>
      recycle_time
    </td>
    
    <td>
      recycletime_index
    </td>
  </tr>
  
  <tr>
    <td>
      time_col
    </td>
    
    <td>
      time
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTc0
    </td>
    
    <td>
      objectClass
    </td>
    
    <td>
      INDEX_00000000
    </td>
  </tr>
  
  <tr>
    <td>
      ATTe2
    </td>
    
    <td>
      knowledgeInformation
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm3
    </td>
    
    <td>
      cn
    </td>
    
    <td>
      INDEX_00000003
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm4
    </td>
    
    <td>
      sn
    </td>
    
    <td>
      INDEX_00000004
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf5
    </td>
    
    <td>
      serialNumber
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm6
    </td>
    
    <td>
      c
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm7
    </td>
    
    <td>
      l
    </td>
    
    <td>
      INDEX_00000007
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm8
    </td>
    
    <td>
      st
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm9
    </td>
    
    <td>
      street
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm10
    </td>
    
    <td>
      o
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm11
    </td>
    
    <td>
      ou
    </td>
    
    <td>
      INDEX_0000000B
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm12
    </td>
    
    <td>
      title
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm13
    </td>
    
    <td>
      description
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk14
    </td>
    
    <td>
      searchGuide
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm15
    </td>
    
    <td>
      businessCategory
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm16
    </td>
    
    <td>
      postalAddress
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm17
    </td>
    
    <td>
      postalCode
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm18
    </td>
    
    <td>
      postOfficeBox
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm19
    </td>
    
    <td>
      physicalDeliveryOfficeName
    </td>
    
    <td>
      INDEX_00000013
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm20
    </td>
    
    <td>
      telephoneNumber
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk21
    </td>
    
    <td>
      telexNumber
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk22
    </td>
    
    <td>
      teletexTerminalIdentifier
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm23
    </td>
    
    <td>
      facsimileTelephoneNumber
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTg24
    </td>
    
    <td>
      x121Address
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTg25
    </td>
    
    <td>
      internationalISDNNumber
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk26
    </td>
    
    <td>
      registeredAddress
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf27
    </td>
    
    <td>
      destinationIndicator
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj28
    </td>
    
    <td>
      preferredDeliveryMethod
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTn29
    </td>
    
    <td>
      presentationAddress
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk30
    </td>
    
    <td>
      supportedApplicationContext
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb33
    </td>
    
    <td>
      roleOccupant
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb34
    </td>
    
    <td>
      seeAlso
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk35
    </td>
    
    <td>
      userPassword
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk36
    </td>
    
    <td>
      userCertificate
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk37
    </td>
    
    <td>
      cACertificate
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk38
    </td>
    
    <td>
      authorityRevocationList
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk39
    </td>
    
    <td>
      certificateRevocationList
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk40
    </td>
    
    <td>
      crossCertificatePair
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm42
    </td>
    
    <td>
      givenName
    </td>
    
    <td>
      INDEX_0000002A
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm43
    </td>
    
    <td>
      initials
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm44
    </td>
    
    <td>
      generationQualifier
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk45
    </td>
    
    <td>
      x500uniqueIdentifier
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb49
    </td>
    
    <td>
      distinguishedName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb50
    </td>
    
    <td>
      uniqueMember
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm51
    </td>
    
    <td>
      houseIdentifier
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk53
    </td>
    
    <td>
      deltaRevocationList
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk58
    </td>
    
    <td>
      attributeCertificateAttribute
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj131073
    </td>
    
    <td>
      instanceType
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTl131074
    </td>
    
    <td>
      whenCreated
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTl131075
    </td>
    
    <td>
      whenChanged
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb131079
    </td>
    
    <td>
      subRefs
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTc131080
    </td>
    
    <td>
      possSuperiors
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk131081
    </td>
    
    <td>
      helpData32
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131085
    </td>
    
    <td>
      displayName
    </td>
    
    <td>
      INDEX_0002000D
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb131088
    </td>
    
    <td>
      nCName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131090
    </td>
    
    <td>
      otherTelephone
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq131091
    </td>
    
    <td>
      uSNCreated
    </td>
    
    <td>
      INDEX_00020013
    </td>
  </tr>
  
  <tr>
    <td>
      ATTc131093
    </td>
    
    <td>
      subClassOf
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTc131094
    </td>
    
    <td>
      governsID
    </td>
    
    <td>
      INDEX_00020016
    </td>
  </tr>
  
  <tr>
    <td>
      ATTc131096
    </td>
    
    <td>
      mustContain
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTc131097
    </td>
    
    <td>
      mayContain
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTc131098
    </td>
    
    <td>
      rDNAttID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTc131102
    </td>
    
    <td>
      attributeID
    </td>
    
    <td>
      INDEX_0002001E
    </td>
  </tr>
  
  <tr>
    <td>
      ATTc131104
    </td>
    
    <td>
      attributeSyntax
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi131105
    </td>
    
    <td>
      isSingleValued
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj131106
    </td>
    
    <td>
      rangeLower
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj131107
    </td>
    
    <td>
      rangeUpper
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb131108
    </td>
    
    <td>
      dMDLocation
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi131120
    </td>
    
    <td>
      isDeleted
    </td>
    
    <td>
      INDEX_00020030
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj131121
    </td>
    
    <td>
      mAPIID
    </td>
    
    <td>
      INDEX_00020031
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj131122
    </td>
    
    <td>
      linkID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj131126
    </td>
    
    <td>
      tombstoneLifetime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk131146
    </td>
    
    <td>
      dSASignature
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj131148
    </td>
    
    <td>
      objectVersion
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131153
    </td>
    
    <td>
      info
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk131155
    </td>
    
    <td>
      repsTo
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk131163
    </td>
    
    <td>
      repsFrom
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk131187
    </td>
    
    <td>
      invocationId
    </td>
    
    <td>
      INDEX_00020073
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131190
    </td>
    
    <td>
      otherPager
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq131192
    </td>
    
    <td>
      uSNChanged
    </td>
    
    <td>
      INDEX_00020078
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq131193
    </td>
    
    <td>
      uSNLastObjRem
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131203
    </td>
    
    <td>
      co
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj131207
    </td>
    
    <td>
      cost
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131213
    </td>
    
    <td>
      department
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131218
    </td>
    
    <td>
      company
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi131241
    </td>
    
    <td>
      showInAdvancedViewOnly
    </td>
    
    <td>
      INDEX_000200A9
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131266
    </td>
    
    <td>
      adminDisplayName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131282
    </td>
    
    <td>
      proxyAddresses
    </td>
    
    <td>
      INDEX_000200D2
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131284
    </td>
    
    <td>
      dSHeuristics
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk131286
    </td>
    
    <td>
      originalDisplayTableMSDOS
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk131290
    </td>
    
    <td>
      oMObjectClass
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131298
    </td>
    
    <td>
      adminDescription
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131299
    </td>
    
    <td>
      extensionName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj131303
    </td>
    
    <td>
      oMSyntax
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk131327
    </td>
    
    <td>
      addressSyntax
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131328
    </td>
    
    <td>
      streetAddress
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq131339
    </td>
    
    <td>
      uSNDSALastObjRemoved
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131349
    </td>
    
    <td>
      otherHomePhone
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTp131353
    </td>
    
    <td>
      nTSecurityDescriptor
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj131373
    </td>
    
    <td>
      garbageCollPeriod
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk131396
    </td>
    
    <td>
      addressEntryDisplayTable
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk131397
    </td>
    
    <td>
      perMsgDialogDisplayTable
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk131398
    </td>
    
    <td>
      perRecipDialogDisplayTable
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131399
    </td>
    
    <td>
      helpFileName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj131406
    </td>
    
    <td>
      searchFlags
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTe131422
    </td>
    
    <td>
      addressType
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTc131423
    </td>
    
    <td>
      auxiliaryClass
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf131425
    </td>
    
    <td>
      displayNamePrintable
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj131442
    </td>
    
    <td>
      objectClassCategory
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi131452
    </td>
    
    <td>
      extendedCharsAllowed
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk131472
    </td>
    
    <td>
      addressEntryDisplayTableMSDOS
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk131474
    </td>
    
    <td>
      helpData16
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131516
    </td>
    
    <td>
      msExchAssistantName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk131517
    </td>
    
    <td>
      originalDisplayTable
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTe131531
    </td>
    
    <td>
      networkAddress
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131532
    </td>
    
    <td>
      lDAPDisplayName
    </td>
    
    <td>
      INDEX_000201CC
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131536
    </td>
    
    <td>
      wWWHomePage
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj131541
    </td>
    
    <td>
      USNIntersite
    </td>
    
    <td>
      INDEX_000201D5
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj131543
    </td>
    
    <td>
      schemaVersion
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi131595
    </td>
    
    <td>
      proxyGenerationEnabled
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi131629
    </td>
    
    <td>
      Enabled
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131665
    </td>
    
    <td>
      msExchLabeledURI
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131668
    </td>
    
    <td>
      msExchHouseIdentifier
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131670
    </td>
    
    <td>
      dmdName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131682
    </td>
    
    <td>
      employeeNumber
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131685
    </td>
    
    <td>
      employeeType
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131687
    </td>
    
    <td>
      personalTitle
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm131689
    </td>
    
    <td>
      homePostalAddress
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589825
    </td>
    
    <td>
      name
    </td>
    
    <td>
      INDEX_00090001
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589826
    </td>
    
    <td>
      objectGUID
    </td>
    
    <td>
      INDEX_00090002
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589827
    </td>
    
    <td>
      replPropertyMetaData
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589828
    </td>
    
    <td>
      replUpToDateVector
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589832
    </td>
    
    <td>
      userAccountControl
    </td>
    
    <td>
      INDEX_00090008
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589835
    </td>
    
    <td>
      authenticationOptions
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589836
    </td>
    
    <td>
      badPwdCount
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589837
    </td>
    
    <td>
      builtinCreationTime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589838
    </td>
    
    <td>
      builtinModifiedCount
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589839
    </td>
    
    <td>
      msiScriptPath
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589840
    </td>
    
    <td>
      codePage
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589843
    </td>
    
    <td>
      cOMClassID
    </td>
    
    <td>
      INDEX_00090013
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589844
    </td>
    
    <td>
      cOMInterfaceID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589845
    </td>
    
    <td>
      cOMProgID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi589848
    </td>
    
    <td>
      contentIndexingAllowed
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589849
    </td>
    
    <td>
      countryCode
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589850
    </td>
    
    <td>
      creationTime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589851
    </td>
    
    <td>
      currentValue
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589852
    </td>
    
    <td>
      dnsRoot
    </td>
    
    <td>
      INDEX_0009001C
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589855
    </td>
    
    <td>
      fRSReplicaSetType
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb589856
    </td>
    
    <td>
      domainPolicyObject
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589859
    </td>
    
    <td>
      employeeID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi589860
    </td>
    
    <td>
      enabledConnection
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589862
    </td>
    
    <td>
      flags
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589863
    </td>
    
    <td>
      forceLogoff
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb589864
    </td>
    
    <td>
      fromServer
    </td>
    
    <td>
      INDEX_00090028
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi589865
    </td>
    
    <td>
      generatedConnection
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589867
    </td>
    
    <td>
      fRSVersionGUID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589868
    </td>
    
    <td>
      homeDirectory
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589869
    </td>
    
    <td>
      homeDrive
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589872
    </td>
    
    <td>
      keywords
    </td>
    
    <td>
      INDEX_00090030
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589873
    </td>
    
    <td>
      badPasswordTime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589874
    </td>
    
    <td>
      lastContentIndexed
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589875
    </td>
    
    <td>
      lastLogoff
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589876
    </td>
    
    <td>
      lastLogon
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589877
    </td>
    
    <td>
      lastSetTime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589879
    </td>
    
    <td>
      dBCSPwd
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589880
    </td>
    
    <td>
      localPolicyFlags
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb589881
    </td>
    
    <td>
      defaultLocalPolicyObject
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589882
    </td>
    
    <td>
      localeID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589884
    </td>
    
    <td>
      lockoutDuration
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589885
    </td>
    
    <td>
      lockOutObservationWindow
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589886
    </td>
    
    <td>
      scriptPath
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589888
    </td>
    
    <td>
      logonHours
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589889
    </td>
    
    <td>
      logonWorkstation
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589890
    </td>
    
    <td>
      lSACreationTime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589891
    </td>
    
    <td>
      lSAModifiedCount
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589892
    </td>
    
    <td>
      machineArchitecture
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589895
    </td>
    
    <td>
      machineRole
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589896
    </td>
    
    <td>
      marshalledInterface
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589897
    </td>
    
    <td>
      lockoutThreshold
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589898
    </td>
    
    <td>
      maxPwdAge
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589899
    </td>
    
    <td>
      maxRenewAge
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589900
    </td>
    
    <td>
      maxStorage
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589901
    </td>
    
    <td>
      maxTicketAge
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589902
    </td>
    
    <td>
      minPwdAge
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589903
    </td>
    
    <td>
      minPwdLength
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589904
    </td>
    
    <td>
      minTicketAge
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589905
    </td>
    
    <td>
      modifiedCountAtLastProm
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589906
    </td>
    
    <td>
      moniker
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589907
    </td>
    
    <td>
      monikerDisplayName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589910
    </td>
    
    <td>
      userWorkstations
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589911
    </td>
    
    <td>
      nETBIOSName
    </td>
    
    <td>
      INDEX_00090057
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589912
    </td>
    
    <td>
      nextRid
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589913
    </td>
    
    <td>
      nTGroupMembers
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589914
    </td>
    
    <td>
      unicodePwd
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589915
    </td>
    
    <td>
      otherLoginWorkstations
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589917
    </td>
    
    <td>
      pwdProperties
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589918
    </td>
    
    <td>
      ntPwdHistory
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589919
    </td>
    
    <td>
      pwdHistoryLength
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589920
    </td>
    
    <td>
      pwdLastSet
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb589921
    </td>
    
    <td>
      preferredOU
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589922
    </td>
    
    <td>
      primaryGroupID
    </td>
    
    <td>
      INDEX_00090062
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589923
    </td>
    
    <td>
      priorSetTime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589924
    </td>
    
    <td>
      priorValue
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589925
    </td>
    
    <td>
      privateKey
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589927
    </td>
    
    <td>
      proxyLifetime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589929
    </td>
    
    <td>
      remoteServerName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589931
    </td>
    
    <td>
      remoteSource
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589932
    </td>
    
    <td>
      remoteSourceType
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589933
    </td>
    
    <td>
      replicaSource
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589937
    </td>
    
    <td>
      rpcNsBindings
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589938
    </td>
    
    <td>
      rpcNsGroup
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589939
    </td>
    
    <td>
      rpcNsInterfaceID
    </td>
    
    <td>
      INDEX_00090073
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589941
    </td>
    
    <td>
      rpcNsPriority
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589942
    </td>
    
    <td>
      rpcNsProfileEntry
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589944
    </td>
    
    <td>
      schemaFlagsEx
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTr589945
    </td>
    
    <td>
      securityIdentifier
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589946
    </td>
    
    <td>
      serviceClassID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589947
    </td>
    
    <td>
      serviceClassInfo
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589949
    </td>
    
    <td>
      supplementalCredentials
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589953
    </td>
    
    <td>
      trustAuthIncoming
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589956
    </td>
    
    <td>
      trustDirection
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589957
    </td>
    
    <td>
      trustPartner
    </td>
    
    <td>
      INDEX_00090085
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589958
    </td>
    
    <td>
      trustPosixOffset
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589959
    </td>
    
    <td>
      trustAuthOutgoing
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589960
    </td>
    
    <td>
      trustType
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589961
    </td>
    
    <td>
      uNCName
    </td>
    
    <td>
      INDEX_00090089
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589962
    </td>
    
    <td>
      userParameters
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589963
    </td>
    
    <td>
      profilePath
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589965
    </td>
    
    <td>
      versionNumber
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589966
    </td>
    
    <td>
      winsockAddresses
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589968
    </td>
    
    <td>
      operatorCount
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589969
    </td>
    
    <td>
      revision
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTr589970
    </td>
    
    <td>
      objectSid
    </td>
    
    <td>
      INDEX_00090092
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589972
    </td>
    
    <td>
      schemaIDGUID
    </td>
    
    <td>
      INDEX_00090094
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589973
    </td>
    
    <td>
      attributeSecurityGUID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589974
    </td>
    
    <td>
      adminCount
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589975
    </td>
    
    <td>
      oEMInformation
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589976
    </td>
    
    <td>
      groupAttributes
    </td>
    
    <td>
      INDEX_00090098
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589977
    </td>
    
    <td>
      rid
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589978
    </td>
    
    <td>
      serverState
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589979
    </td>
    
    <td>
      uASCompat
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589980
    </td>
    
    <td>
      comment
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589981
    </td>
    
    <td>
      serverRole
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm589982
    </td>
    
    <td>
      domainReplica
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589983
    </td>
    
    <td>
      accountExpires
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589984
    </td>
    
    <td>
      lmPwdHistory
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk589990
    </td>
    
    <td>
      groupMembershipSAM
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq589992
    </td>
    
    <td>
      modifiedCount
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj589993
    </td>
    
    <td>
      logonCount
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi589994
    </td>
    
    <td>
      systemOnly
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTc590019
    </td>
    
    <td>
      systemPossSuperiors
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTc590020
    </td>
    
    <td>
      systemMayContain
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTc590021
    </td>
    
    <td>
      systemMustContain
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTc590022
    </td>
    
    <td>
      systemAuxiliaryClass
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590023
    </td>
    
    <td>
      serviceInstanceVersion
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590024
    </td>
    
    <td>
      controlAccessRights
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590026
    </td>
    
    <td>
      auditingPolicy
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590029
    </td>
    
    <td>
      pKTGuid
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590030
    </td>
    
    <td>
      pKT
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590035
    </td>
    
    <td>
      schedule
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590037
    </td>
    
    <td>
      defaultClassStore
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590038
    </td>
    
    <td>
      nextLevelStore
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590042
    </td>
    
    <td>
      applicationName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590043
    </td>
    
    <td>
      iconPath
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590045
    </td>
    
    <td>
      sAMAccountName
    </td>
    
    <td>
      INDEX_000900DD
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590046
    </td>
    
    <td>
      location
    </td>
    
    <td>
      INDEX_000900DE
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590047
    </td>
    
    <td>
      serverName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590048
    </td>
    
    <td>
      defaultSecurityDescriptor
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590052
    </td>
    
    <td>
      portName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590053
    </td>
    
    <td>
      driverName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590054
    </td>
    
    <td>
      printSeparatorFile
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590055
    </td>
    
    <td>
      priority
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590056
    </td>
    
    <td>
      defaultPriority
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590057
    </td>
    
    <td>
      printStartTime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590058
    </td>
    
    <td>
      printEndTime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590059
    </td>
    
    <td>
      printFormName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590061
    </td>
    
    <td>
      printBinNames
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590062
    </td>
    
    <td>
      printMaxResolutionSupported
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590064
    </td>
    
    <td>
      printOrientationsSupported
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590065
    </td>
    
    <td>
      printMaxCopies
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590066
    </td>
    
    <td>
      printCollate
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590067
    </td>
    
    <td>
      printColor
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590070
    </td>
    
    <td>
      printLanguage
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590071
    </td>
    
    <td>
      printAttributes
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590073
    </td>
    
    <td>
      cOMCLSID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590074
    </td>
    
    <td>
      cOMUniqueLIBID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590075
    </td>
    
    <td>
      cOMTreatAsClassId
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590077
    </td>
    
    <td>
      cOMOtherProgId
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590078
    </td>
    
    <td>
      cOMTypelibId
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590079
    </td>
    
    <td>
      vendor
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590085
    </td>
    
    <td>
      division
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590089
    </td>
    
    <td>
      notes
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590092
    </td>
    
    <td>
      eFSPolicy
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590093
    </td>
    
    <td>
      linkTrackSecret
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590094
    </td>
    
    <td>
      printShareName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590095
    </td>
    
    <td>
      printOwner
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590096
    </td>
    
    <td>
      printNotify
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590097
    </td>
    
    <td>
      printStatus
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590098
    </td>
    
    <td>
      printSpooling
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590099
    </td>
    
    <td>
      printKeepPrintedJobs
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590100
    </td>
    
    <td>
      driverVersion
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590101
    </td>
    
    <td>
      printMaxXExtent
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590102
    </td>
    
    <td>
      printMaxYExtent
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590103
    </td>
    
    <td>
      printMinXExtent
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590104
    </td>
    
    <td>
      printMinYExtent
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590105
    </td>
    
    <td>
      printStaplingSupported
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590106
    </td>
    
    <td>
      printMemory
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590107
    </td>
    
    <td>
      assetNumber
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590108
    </td>
    
    <td>
      bytesPerMinute
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590109
    </td>
    
    <td>
      printRate
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590110
    </td>
    
    <td>
      printRateUnit
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590111
    </td>
    
    <td>
      printNetworkAddress
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590112
    </td>
    
    <td>
      printMACAddress
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590113
    </td>
    
    <td>
      printMediaReady
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590114
    </td>
    
    <td>
      printNumberUp
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590123
    </td>
    
    <td>
      printMediaSupported
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590124
    </td>
    
    <td>
      printerName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590125
    </td>
    
    <td>
      wbemPath
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590126
    </td>
    
    <td>
      sAMAccountType
    </td>
    
    <td>
      INDEX_0009012E
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590127
    </td>
    
    <td>
      notificationList
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590131
    </td>
    
    <td>
      options
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590136
    </td>
    
    <td>
      rpcNsObjectID
    </td>
    
    <td>
      INDEX_00090138
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590138
    </td>
    
    <td>
      rpcNsTransferSyntax
    </td>
    
    <td>
      INDEX_0009013A
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590144
    </td>
    
    <td>
      implementedCategories
    </td>
    
    <td>
      INDEX_00090140
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590145
    </td>
    
    <td>
      requiredCategories
    </td>
    
    <td>
      INDEX_00090141
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590146
    </td>
    
    <td>
      categoryId
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590148
    </td>
    
    <td>
      packageType
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590149
    </td>
    
    <td>
      setupCommand
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590150
    </td>
    
    <td>
      packageName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590151
    </td>
    
    <td>
      packageFlags
    </td>
    
    <td>
      INDEX_00090147
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590152
    </td>
    
    <td>
      versionNumberHi
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590153
    </td>
    
    <td>
      versionNumberLo
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590154
    </td>
    
    <td>
      lastUpdateSequence
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590156
    </td>
    
    <td>
      birthLocation
    </td>
    
    <td>
      INDEX_0009014C
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590157
    </td>
    
    <td>
      oMTIndxGuid
    </td>
    
    <td>
      INDEX_0009014D
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590158
    </td>
    
    <td>
      volTableIdxGUID
    </td>
    
    <td>
      INDEX_0009014E
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590159
    </td>
    
    <td>
      currentLocation
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590160
    </td>
    
    <td>
      volTableGUID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590161
    </td>
    
    <td>
      currMachineId
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590164
    </td>
    
    <td>
      rightsGuid
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590165
    </td>
    
    <td>
      appliesTo
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590168
    </td>
    
    <td>
      groupsToIgnore
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590169
    </td>
    
    <td>
      groupPriority
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590170
    </td>
    
    <td>
      desktopProfile
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590180
    </td>
    
    <td>
      foreignIdentifier
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590181
    </td>
    
    <td>
      nTMixedDomain
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590182
    </td>
    
    <td>
      netbootInitialization
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590183
    </td>
    
    <td>
      netbootGUID
    </td>
    
    <td>
      INDEX_00090167
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590185
    </td>
    
    <td>
      netbootMachineFilePath
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590186
    </td>
    
    <td>
      siteGUID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590187
    </td>
    
    <td>
      operatingSystem
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590188
    </td>
    
    <td>
      operatingSystemVersion
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590189
    </td>
    
    <td>
      operatingSystemServicePack
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590190
    </td>
    
    <td>
      rpcNsAnnotation
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590191
    </td>
    
    <td>
      rpcNsCodeset
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590192
    </td>
    
    <td>
      rIDManagerReference
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590193
    </td>
    
    <td>
      fSMORoleOwner
    </td>
    
    <td>
      INDEX_00090171
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590194
    </td>
    
    <td>
      rIDAvailablePool
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590195
    </td>
    
    <td>
      rIDAllocationPool
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590196
    </td>
    
    <td>
      rIDPreviousAllocationPool
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590197
    </td>
    
    <td>
      rIDUsedPool
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590198
    </td>
    
    <td>
      rIDNextRID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590199
    </td>
    
    <td>
      systemFlags
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590202
    </td>
    
    <td>
      dnsAllowDynamic
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590203
    </td>
    
    <td>
      dnsAllowXFR
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590204
    </td>
    
    <td>
      dnsSecureSecondaries
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590205
    </td>
    
    <td>
      dnsNotifySecondaries
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590206
    </td>
    
    <td>
      dnsRecord
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590239
    </td>
    
    <td>
      operatingSystemHotfix
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590244
    </td>
    
    <td>
      publicKeyPolicy
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590245
    </td>
    
    <td>
      domainWidePolicy
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590246
    </td>
    
    <td>
      domainPolicyReference
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590281
    </td>
    
    <td>
      localPolicyReference
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590282
    </td>
    
    <td>
      qualityOfService
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590283
    </td>
    
    <td>
      machineWidePolicy
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590294
    </td>
    
    <td>
      trustAttributes
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590295
    </td>
    
    <td>
      trustParent
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590296
    </td>
    
    <td>
      domainCrossRef
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590304
    </td>
    
    <td>
      defaultGroup
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTl590305
    </td>
    
    <td>
      schemaUpdate
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590307
    </td>
    
    <td>
      fRSFileFilter
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590308
    </td>
    
    <td>
      fRSDirectoryFilter
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590309
    </td>
    
    <td>
      fRSUpdateTimeout
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590310
    </td>
    
    <td>
      fRSWorkingPath
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590311
    </td>
    
    <td>
      fRSRootPath
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590312
    </td>
    
    <td>
      fRSStagingPath
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590314
    </td>
    
    <td>
      fRSDSPoll
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590315
    </td>
    
    <td>
      fRSFaultCondition
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590318
    </td>
    
    <td>
      siteServer
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590322
    </td>
    
    <td>
      creationWizard
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590323
    </td>
    
    <td>
      contextMenu
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590324
    </td>
    
    <td>
      fRSServiceCommand
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590326
    </td>
    
    <td>
      timeVolChange
    </td>
    
    <td>
      INDEX_000901F6
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590327
    </td>
    
    <td>
      timeRefresh
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590328
    </td>
    
    <td>
      seqNotification
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590329
    </td>
    
    <td>
      oMTGuid
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590330
    </td>
    
    <td>
      objectCount
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590331
    </td>
    
    <td>
      volumeCount
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590333
    </td>
    
    <td>
      serviceClassName
    </td>
    
    <td>
      INDEX_000901FD
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590334
    </td>
    
    <td>
      serviceBindingInformation
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590335
    </td>
    
    <td>
      flatName
    </td>
    
    <td>
      INDEX_000901FF
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590338
    </td>
    
    <td>
      physicalLocationObject
    </td>
    
    <td>
      INDEX_00090202
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590341
    </td>
    
    <td>
      ipsecPolicyReference
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590342
    </td>
    
    <td>
      defaultHidingValue
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590343
    </td>
    
    <td>
      lastBackupRestorationTime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590344
    </td>
    
    <td>
      machinePasswordChangeInterval
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590356
    </td>
    
    <td>
      superiorDNSRoot
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590357
    </td>
    
    <td>
      fRSReplicaSetGUID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590358
    </td>
    
    <td>
      fRSLevelLimit
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTp590359
    </td>
    
    <td>
      fRSRootSecurity
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590360
    </td>
    
    <td>
      fRSExtensions
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590361
    </td>
    
    <td>
      dynamicLDAPServer
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590362
    </td>
    
    <td>
      prefixMap
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590363
    </td>
    
    <td>
      initialAuthIncoming
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590364
    </td>
    
    <td>
      initialAuthOutgoing
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590381
    </td>
    
    <td>
      parentCA
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590386
    </td>
    
    <td>
      adminPropertyPages
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590387
    </td>
    
    <td>
      shellPropertyPages
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590389
    </td>
    
    <td>
      meetingID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590390
    </td>
    
    <td>
      meetingName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590391
    </td>
    
    <td>
      meetingDescription
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590392
    </td>
    
    <td>
      meetingKeyword
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590393
    </td>
    
    <td>
      meetingLocation
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590394
    </td>
    
    <td>
      meetingProtocol
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590395
    </td>
    
    <td>
      meetingType
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590397
    </td>
    
    <td>
      meetingApplication
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590398
    </td>
    
    <td>
      meetingLanguage
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590400
    </td>
    
    <td>
      meetingMaxParticipants
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590401
    </td>
    
    <td>
      meetingOriginator
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590402
    </td>
    
    <td>
      meetingContactInfo
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590403
    </td>
    
    <td>
      meetingOwner
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590404
    </td>
    
    <td>
      meetingIP
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590405
    </td>
    
    <td>
      meetingScope
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590406
    </td>
    
    <td>
      meetingAdvertiseScope
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590407
    </td>
    
    <td>
      meetingURL
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590408
    </td>
    
    <td>
      meetingRating
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590409
    </td>
    
    <td>
      meetingIsEncrypted
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590410
    </td>
    
    <td>
      meetingRecurrence
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTl590411
    </td>
    
    <td>
      meetingStartTime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTl590412
    </td>
    
    <td>
      meetingEndTime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590413
    </td>
    
    <td>
      meetingBandwidth
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590414
    </td>
    
    <td>
      meetingBlob
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTr590433
    </td>
    
    <td>
      sIDHistory
    </td>
    
    <td>
      INDEX_00090261
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590434
    </td>
    
    <td>
      classDisplayName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590438
    </td>
    
    <td>
      adminContextMenu
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590439
    </td>
    
    <td>
      shellContextMenu
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTh590442
    </td>
    
    <td>
      wellKnownObjects
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590443
    </td>
    
    <td>
      dNSHostName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590444
    </td>
    
    <td>
      ipsecName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590445
    </td>
    
    <td>
      ipsecID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590446
    </td>
    
    <td>
      ipsecDataType
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590447
    </td>
    
    <td>
      ipsecData
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590448
    </td>
    
    <td>
      ipsecOwnersReference
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590450
    </td>
    
    <td>
      ipsecISAKMPReference
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590451
    </td>
    
    <td>
      ipsecNFAReference
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590452
    </td>
    
    <td>
      ipsecNegotiationPolicyReference
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590453
    </td>
    
    <td>
      ipsecFilterReference
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590455
    </td>
    
    <td>
      printPagesPerMinute
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590457
    </td>
    
    <td>
      policyReplicationFlags
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590458
    </td>
    
    <td>
      privilegeDisplayName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590459
    </td>
    
    <td>
      privilegeValue
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590460
    </td>
    
    <td>
      privilegeAttributes
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590463
    </td>
    
    <td>
      isMemberOfPartialAttributeSet
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590464
    </td>
    
    <td>
      partialAttributeSet
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590468
    </td>
    
    <td>
      showInAddressBook
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590469
    </td>
    
    <td>
      userCert
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590470
    </td>
    
    <td>
      otherFacsimileTelephoneNumber
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590471
    </td>
    
    <td>
      otherMobile
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590472
    </td>
    
    <td>
      primaryTelexNumber
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590473
    </td>
    
    <td>
      primaryInternationalISDNNumber
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590474
    </td>
    
    <td>
      mhsORAddress
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590475
    </td>
    
    <td>
      otherMailbox
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590476
    </td>
    
    <td>
      assistant
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTe590479
    </td>
    
    <td>
      legacyExchangeDN
    </td>
    
    <td>
      INDEX_0009028F
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590480
    </td>
    
    <td>
      userPrincipalName
    </td>
    
    <td>
      INDEX_00090290
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590481
    </td>
    
    <td>
      serviceDNSName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590483
    </td>
    
    <td>
      serviceDNSNameType
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590484
    </td>
    
    <td>
      treeName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590485
    </td>
    
    <td>
      isDefunct
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590486
    </td>
    
    <td>
      lockoutTime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590487
    </td>
    
    <td>
      partialAttributeDeletionList
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590488
    </td>
    
    <td>
      syncWithObject
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590490
    </td>
    
    <td>
      syncAttributes
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTr590491
    </td>
    
    <td>
      syncWithSID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590492
    </td>
    
    <td>
      domainCAs
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590493
    </td>
    
    <td>
      rIDSetReferences
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590495
    </td>
    
    <td>
      msiFileList
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590496
    </td>
    
    <td>
      categories
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590497
    </td>
    
    <td>
      retiredReplDSASignatures
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590498
    </td>
    
    <td>
      rootTrust
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590499
    </td>
    
    <td>
      catalogs
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590501
    </td>
    
    <td>
      replTopologyStayOfExecution
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590503
    </td>
    
    <td>
      creator
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590504
    </td>
    
    <td>
      queryPoint
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590505
    </td>
    
    <td>
      indexedScopes
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590506
    </td>
    
    <td>
      friendlyNames
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590507
    </td>
    
    <td>
      cRLPartitionedRevocationList
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590508
    </td>
    
    <td>
      certificateAuthorityObject
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590509
    </td>
    
    <td>
      parentCACertificateChain
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590510
    </td>
    
    <td>
      domainID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590511
    </td>
    
    <td>
      cAConnect
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590512
    </td>
    
    <td>
      cAWEBURL
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590513
    </td>
    
    <td>
      cRLObject
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590514
    </td>
    
    <td>
      cAUsages
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590516
    </td>
    
    <td>
      previousCACertificates
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590517
    </td>
    
    <td>
      pendingCACertificates
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590518
    </td>
    
    <td>
      previousParentCA
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590519
    </td>
    
    <td>
      pendingParentCA
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590520
    </td>
    
    <td>
      currentParentCA
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590521
    </td>
    
    <td>
      cACertificateDN
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590522
    </td>
    
    <td>
      dhcpUniqueKey
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590523
    </td>
    
    <td>
      dhcpType
    </td>
    
    <td>
      INDEX_000902BB
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590524
    </td>
    
    <td>
      dhcpFlags
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590525
    </td>
    
    <td>
      dhcpIdentification
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590526
    </td>
    
    <td>
      dhcpObjName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590527
    </td>
    
    <td>
      dhcpObjDescription
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf590528
    </td>
    
    <td>
      dhcpServers
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf590529
    </td>
    
    <td>
      dhcpSubnets
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf590530
    </td>
    
    <td>
      dhcpMask
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf590531
    </td>
    
    <td>
      dhcpRanges
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf590532
    </td>
    
    <td>
      dhcpSites
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf590533
    </td>
    
    <td>
      dhcpReservations
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf590534
    </td>
    
    <td>
      superScopes
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590535
    </td>
    
    <td>
      superScopeDescription
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590536
    </td>
    
    <td>
      optionDescription
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf590537
    </td>
    
    <td>
      optionsLocation
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590538
    </td>
    
    <td>
      dhcpOptions
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590539
    </td>
    
    <td>
      dhcpClasses
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf590540
    </td>
    
    <td>
      mscopeId
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf590541
    </td>
    
    <td>
      dhcpState
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590542
    </td>
    
    <td>
      dhcpProperties
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590543
    </td>
    
    <td>
      dhcpMaxKey
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590544
    </td>
    
    <td>
      dhcpUpdateTime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590545
    </td>
    
    <td>
      ipPhone
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590546
    </td>
    
    <td>
      otherIpPhone
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590572
    </td>
    
    <td>
      attributeDisplayNames
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590573
    </td>
    
    <td>
      url
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590574
    </td>
    
    <td>
      groupType
    </td>
    
    <td>
      INDEX_000902EE
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590575
    </td>
    
    <td>
      userSharedFolder
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590576
    </td>
    
    <td>
      userSharedFolderOther
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590577
    </td>
    
    <td>
      nameServiceFlags
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590578
    </td>
    
    <td>
      rpcNsEntryFlags
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590579
    </td>
    
    <td>
      domainIdentifier
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590580
    </td>
    
    <td>
      aCSTimeOfDay
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590581
    </td>
    
    <td>
      aCSDirection
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590582
    </td>
    
    <td>
      aCSMaxTokenRatePerFlow
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590583
    </td>
    
    <td>
      aCSMaxPeakBandwidthPerFlow
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590584
    </td>
    
    <td>
      aCSAggregateTokenRatePerUser
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590585
    </td>
    
    <td>
      aCSMaxDurationPerFlow
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590586
    </td>
    
    <td>
      aCSServiceType
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590587
    </td>
    
    <td>
      aCSTotalNoOfFlows
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590588
    </td>
    
    <td>
      aCSPriority
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590589
    </td>
    
    <td>
      aCSPermissionBits
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590590
    </td>
    
    <td>
      aCSAllocableRSVPBandwidth
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590591
    </td>
    
    <td>
      aCSMaxPeakBandwidth
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590592
    </td>
    
    <td>
      aCSEnableRSVPMessageLogging
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590593
    </td>
    
    <td>
      aCSEventLogLevel
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590594
    </td>
    
    <td>
      aCSEnableACSService
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590595
    </td>
    
    <td>
      servicePrincipalName
    </td>
    
    <td>
      INDEX_00090303
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590596
    </td>
    
    <td>
      aCSPolicyName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590597
    </td>
    
    <td>
      aCSRSVPLogFilesLocation
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590598
    </td>
    
    <td>
      aCSMaxNoOfLogFiles
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590599
    </td>
    
    <td>
      aCSMaxSizeOfRSVPLogFile
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590600
    </td>
    
    <td>
      aCSDSBMPriority
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590601
    </td>
    
    <td>
      aCSDSBMRefresh
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590602
    </td>
    
    <td>
      aCSDSBMDeadTime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590603
    </td>
    
    <td>
      aCSCacheTimeout
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590604
    </td>
    
    <td>
      aCSNonReservedTxLimit
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590605
    </td>
    
    <td>
      lastKnownParent
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590606
    </td>
    
    <td>
      objectCategory
    </td>
    
    <td>
      INDEX_0009030E
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590607
    </td>
    
    <td>
      defaultObjectCategory
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590608
    </td>
    
    <td>
      aCSIdentityName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590610
    </td>
    
    <td>
      mailAddress
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590613
    </td>
    
    <td>
      transportDLLName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590615
    </td>
    
    <td>
      transportType
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590630
    </td>
    
    <td>
      treatAsLeaf
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590633
    </td>
    
    <td>
      remoteStorageGUID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590634
    </td>
    
    <td>
      createDialog
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590636
    </td>
    
    <td>
      createWizardExt
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590637
    </td>
    
    <td>
      upgradeProductCode
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590638
    </td>
    
    <td>
      msiScript
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590639
    </td>
    
    <td>
      canUpgradeScript
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590640
    </td>
    
    <td>
      fileExtPriority
    </td>
    
    <td>
      INDEX_00090330
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590641
    </td>
    
    <td>
      localizedDescription
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590642
    </td>
    
    <td>
      productCode
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590647
    </td>
    
    <td>
      certificateTemplates
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590648
    </td>
    
    <td>
      signatureAlgorithms
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590649
    </td>
    
    <td>
      enrollmentProviders
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590667
    </td>
    
    <td>
      lDAPAdminLimits
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590668
    </td>
    
    <td>
      lDAPIPDenyList
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590669
    </td>
    
    <td>
      msiScriptName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590670
    </td>
    
    <td>
      msiScriptSize
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590671
    </td>
    
    <td>
      installUiLevel
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590672
    </td>
    
    <td>
      appSchemaVersion
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590673
    </td>
    
    <td>
      netbootAllowNewClients
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590674
    </td>
    
    <td>
      netbootLimitClients
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590675
    </td>
    
    <td>
      netbootMaxClients
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590676
    </td>
    
    <td>
      netbootCurrentClientCount
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590677
    </td>
    
    <td>
      netbootAnswerRequests
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590678
    </td>
    
    <td>
      netbootAnswerOnlyValidClients
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590679
    </td>
    
    <td>
      netbootNewMachineNamingPolicy
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590680
    </td>
    
    <td>
      netbootNewMachineOU
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590681
    </td>
    
    <td>
      netbootIntelliMirrorOSes
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590682
    </td>
    
    <td>
      netbootTools
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590683
    </td>
    
    <td>
      netbootLocallyInstalledOSes
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590689
    </td>
    
    <td>
      pekList
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590690
    </td>
    
    <td>
      pekKeyChangeInterval
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590691
    </td>
    
    <td>
      altSecurityIdentities
    </td>
    
    <td>
      INDEX_00090363
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590692
    </td>
    
    <td>
      isCriticalSystemObject
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590695
    </td>
    
    <td>
      fRSControlDataCreation
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590696
    </td>
    
    <td>
      fRSControlInboundBacklog
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590697
    </td>
    
    <td>
      fRSControlOutboundBacklog
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590698
    </td>
    
    <td>
      fRSFlags
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590701
    </td>
    
    <td>
      fRSPartnerAuthLevel
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590703
    </td>
    
    <td>
      fRSServiceCommandStatus
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTl590704
    </td>
    
    <td>
      fRSTimeLastCommand
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTl590705
    </td>
    
    <td>
      fRSTimeLastConfigChange
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590706
    </td>
    
    <td>
      fRSVersion
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590707
    </td>
    
    <td>
      msRRASVendorAttributeEntry
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590708
    </td>
    
    <td>
      msRRASAttribute
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590709
    </td>
    
    <td>
      terminalServer
    </td>
    
    <td>
      INDEX_00090375
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590710
    </td>
    
    <td>
      purportedSearch
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590711
    </td>
    
    <td>
      iPSECNegotiationPolicyType
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590712
    </td>
    
    <td>
      iPSECNegotiationPolicyAction
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590713
    </td>
    
    <td>
      additionalTrustedServiceNames
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590714
    </td>
    
    <td>
      uPNSuffixes
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590715
    </td>
    
    <td>
      gPLink
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590716
    </td>
    
    <td>
      gPOptions
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590717
    </td>
    
    <td>
      gPCFunctionalityVersion
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590718
    </td>
    
    <td>
      gPCFileSysPath
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTc590719
    </td>
    
    <td>
      transportAddressAttribute
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590720
    </td>
    
    <td>
      uSNSource
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590721
    </td>
    
    <td>
      aCSMaxAggregatePeakRatePerUser
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq590722
    </td>
    
    <td>
      aCSNonReservedTxSize
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590723
    </td>
    
    <td>
      aCSEnableRSVPAccounting
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm590724
    </td>
    
    <td>
      aCSRSVPAccountFilesLocation
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590725
    </td>
    
    <td>
      aCSMaxNoOfAccountFiles
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590726
    </td>
    
    <td>
      aCSMaxSizeOfRSVPAccountFile
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590741
    </td>
    
    <td>
      mSMQQueueType
    </td>
    
    <td>
      INDEX_00090395
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590742
    </td>
    
    <td>
      mSMQJournal
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590743
    </td>
    
    <td>
      mSMQQuota
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590744
    </td>
    
    <td>
      mSMQBasePriority
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590745
    </td>
    
    <td>
      mSMQJournalQuota
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTe590746
    </td>
    
    <td>
      mSMQLabel
    </td>
    
    <td>
      INDEX_0009039A
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590747
    </td>
    
    <td>
      mSMQAuthenticate
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590748
    </td>
    
    <td>
      mSMQPrivacyLevel
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590749
    </td>
    
    <td>
      mSMQOwnerID
    </td>
    
    <td>
      INDEX_0009039D
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590750
    </td>
    
    <td>
      mSMQTransactional
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590751
    </td>
    
    <td>
      mSMQSites
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590752
    </td>
    
    <td>
      mSMQOutRoutingServers
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590753
    </td>
    
    <td>
      mSMQInRoutingServers
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590754
    </td>
    
    <td>
      mSMQServiceType
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTe590757
    </td>
    
    <td>
      mSMQComputerType
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590758
    </td>
    
    <td>
      mSMQForeign
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590759
    </td>
    
    <td>
      mSMQOSType
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590760
    </td>
    
    <td>
      mSMQEncryptKey
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590761
    </td>
    
    <td>
      mSMQSignKey
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590763
    </td>
    
    <td>
      mSMQNameStyle
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTe590764
    </td>
    
    <td>
      mSMQCSPName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590765
    </td>
    
    <td>
      mSMQLongLived
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590766
    </td>
    
    <td>
      mSMQVersion
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590767
    </td>
    
    <td>
      mSMQSite1
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590768
    </td>
    
    <td>
      mSMQSite2
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb590769
    </td>
    
    <td>
      mSMQSiteGates
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590770
    </td>
    
    <td>
      mSMQCost
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590771
    </td>
    
    <td>
      mSMQSignCertificates
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590772
    </td>
    
    <td>
      mSMQDigests
    </td>
    
    <td>
      INDEX_000903B4
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590774
    </td>
    
    <td>
      mSMQServices
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590775
    </td>
    
    <td>
      mSMQQMID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590776
    </td>
    
    <td>
      mSMQMigrated
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590777
    </td>
    
    <td>
      mSMQSiteID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590784
    </td>
    
    <td>
      mSMQNt4Stub
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590785
    </td>
    
    <td>
      mSMQSiteForeign
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590786
    </td>
    
    <td>
      mSMQQueueQuota
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590787
    </td>
    
    <td>
      mSMQQueueJournalQuota
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590788
    </td>
    
    <td>
      mSMQNt4Flags
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTe590789
    </td>
    
    <td>
      mSMQSiteName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590790
    </td>
    
    <td>
      mSMQDigestsMig
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk590791
    </td>
    
    <td>
      mSMQSignCertificatesMig
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi590943
    </td>
    
    <td>
      msNPAllowDialin
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf590947
    </td>
    
    <td>
      msNPCalledStationID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf590948
    </td>
    
    <td>
      msNPCallingStationID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf590954
    </td>
    
    <td>
      msNPSavedCallingStationID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf590969
    </td>
    
    <td>
      msRADIUSCallbackNumber
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590977
    </td>
    
    <td>
      msRADIUSFramedIPAddress
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf590982
    </td>
    
    <td>
      msRADIUSFramedRoute
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj590995
    </td>
    
    <td>
      msRADIUSServiceType
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf591013
    </td>
    
    <td>
      msRASSavedCallbackNumber
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591014
    </td>
    
    <td>
      msRASSavedFramedIPAddress
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf591015
    </td>
    
    <td>
      msRASSavedFramedRoute
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591033
    </td>
    
    <td>
      shortServerName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591036
    </td>
    
    <td>
      isEphemeral
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591037
    </td>
    
    <td>
      assocNTAccount
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb591049
    </td>
    
    <td>
      mSMQPrevSiteGates
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591050
    </td>
    
    <td>
      mSMQDependentClientServices
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591051
    </td>
    
    <td>
      mSMQRoutingServices
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591052
    </td>
    
    <td>
      mSMQDsServices
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591061
    </td>
    
    <td>
      mSMQRoutingService
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591062
    </td>
    
    <td>
      mSMQDsService
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591063
    </td>
    
    <td>
      mSMQDependentClientService
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591064
    </td>
    
    <td>
      netbootSIFFile
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591065
    </td>
    
    <td>
      netbootMirrorDataFile
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb591066
    </td>
    
    <td>
      dNReferenceUpdate
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591067
    </td>
    
    <td>
      mSMQQueueNameExt
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb591068
    </td>
    
    <td>
      addressBookRoots
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb591069
    </td>
    
    <td>
      globalAddressList
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb591070
    </td>
    
    <td>
      interSiteTopologyGenerator
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591071
    </td>
    
    <td>
      interSiteTopologyRenew
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591072
    </td>
    
    <td>
      interSiteTopologyFailover
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTh591073
    </td>
    
    <td>
      proxiedObjectName
    </td>
    
    <td>
      INDEX_000904E1
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591129
    </td>
    
    <td>
      moveTreeState
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591130
    </td>
    
    <td>
      dNSProperty
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591131
    </td>
    
    <td>
      accountNameHistory
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591132
    </td>
    
    <td>
      mSMQInterval1
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591133
    </td>
    
    <td>
      mSMQInterval2
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb591134
    </td>
    
    <td>
      mSMQSiteGatesMig
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591135
    </td>
    
    <td>
      printDuplexSupported
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591136
    </td>
    
    <td>
      aCSServerList
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591137
    </td>
    
    <td>
      aCSMaxTokenBucketPerFlow
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591138
    </td>
    
    <td>
      aCSMaximumSDUSize
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591139
    </td>
    
    <td>
      aCSMinimumPolicedSize
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591140
    </td>
    
    <td>
      aCSMinimumLatency
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591141
    </td>
    
    <td>
      aCSMinimumDelayVariation
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591142
    </td>
    
    <td>
      aCSNonReservedPeakRate
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591143
    </td>
    
    <td>
      aCSNonReservedTokenSize
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591144
    </td>
    
    <td>
      aCSNonReservedMaxSDUSize
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591145
    </td>
    
    <td>
      aCSNonReservedMinPolicedSize
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591151
    </td>
    
    <td>
      pKIDefaultKeySpec
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591152
    </td>
    
    <td>
      pKIKeyUsage
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591153
    </td>
    
    <td>
      pKIMaxIssuingDepth
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591154
    </td>
    
    <td>
      pKICriticalExtensions
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591155
    </td>
    
    <td>
      pKIExpirationPeriod
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591156
    </td>
    
    <td>
      pKIOverlapPeriod
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591157
    </td>
    
    <td>
      pKIExtendedKeyUsage
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591158
    </td>
    
    <td>
      pKIDefaultCSPs
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTp591159
    </td>
    
    <td>
      pKIEnrollmentAccess
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591160
    </td>
    
    <td>
      replInterval
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591161
    </td>
    
    <td>
      mSMQUserSid
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591167
    </td>
    
    <td>
      dSUIAdminNotification
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591168
    </td>
    
    <td>
      dSUIAdminMaximum
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591169
    </td>
    
    <td>
      dSUIShellMaximum
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb591170
    </td>
    
    <td>
      templateRoots
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591171
    </td>
    
    <td>
      sPNMappings
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591172
    </td>
    
    <td>
      gPCMachineExtensionNames
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591173
    </td>
    
    <td>
      gPCUserExtensionNames
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591177
    </td>
    
    <td>
      localizationDisplayId
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591178
    </td>
    
    <td>
      scopeFlags
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591179
    </td>
    
    <td>
      queryFilter
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591180
    </td>
    
    <td>
      validAccesses
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTl591181
    </td>
    
    <td>
      dSCorePropagationData
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591182
    </td>
    
    <td>
      schemaInfo
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTh591183
    </td>
    
    <td>
      otherWellKnownObjects
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591184
    </td>
    
    <td>
      mS-DS-ConsistencyGuid
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591185
    </td>
    
    <td>
      mS-DS-ConsistencyChildCount
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591187
    </td>
    
    <td>
      mS-SQL-Name
    </td>
    
    <td>
      INDEX_00090553
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591188
    </td>
    
    <td>
      mS-SQL-RegisteredOwner
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591189
    </td>
    
    <td>
      mS-SQL-Contact
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591190
    </td>
    
    <td>
      mS-SQL-Location
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591191
    </td>
    
    <td>
      mS-SQL-Memory
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591192
    </td>
    
    <td>
      mS-SQL-Build
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591193
    </td>
    
    <td>
      mS-SQL-ServiceAccount
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591194
    </td>
    
    <td>
      mS-SQL-CharacterSet
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591195
    </td>
    
    <td>
      mS-SQL-SortOrder
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591196
    </td>
    
    <td>
      mS-SQL-UnicodeSortOrder
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591197
    </td>
    
    <td>
      mS-SQL-Clustered
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591198
    </td>
    
    <td>
      mS-SQL-NamedPipe
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591199
    </td>
    
    <td>
      mS-SQL-MultiProtocol
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591200
    </td>
    
    <td>
      mS-SQL-SPX
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591201
    </td>
    
    <td>
      mS-SQL-TCPIP
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591202
    </td>
    
    <td>
      mS-SQL-AppleTalk
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591203
    </td>
    
    <td>
      mS-SQL-Vines
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591204
    </td>
    
    <td>
      mS-SQL-Status
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591205
    </td>
    
    <td>
      mS-SQL-LastUpdatedDate
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591206
    </td>
    
    <td>
      mS-SQL-InformationURL
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591207
    </td>
    
    <td>
      mS-SQL-ConnectionURL
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591208
    </td>
    
    <td>
      mS-SQL-PublicationURL
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591209
    </td>
    
    <td>
      mS-SQL-GPSLatitude
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591210
    </td>
    
    <td>
      mS-SQL-GPSLongitude
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591211
    </td>
    
    <td>
      mS-SQL-GPSHeight
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591212
    </td>
    
    <td>
      mS-SQL-Version
    </td>
    
    <td>
      INDEX_0009056C
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591213
    </td>
    
    <td>
      mS-SQL-Language
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591214
    </td>
    
    <td>
      mS-SQL-Description
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591215
    </td>
    
    <td>
      mS-SQL-Type
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591216
    </td>
    
    <td>
      mS-SQL-InformationDirectory
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591217
    </td>
    
    <td>
      mS-SQL-Database
    </td>
    
    <td>
      INDEX_00090571
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591218
    </td>
    
    <td>
      mS-SQL-AllowAnonymousSubscription
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591219
    </td>
    
    <td>
      mS-SQL-Alias
    </td>
    
    <td>
      INDEX_00090573
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591220
    </td>
    
    <td>
      mS-SQL-Size
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591221
    </td>
    
    <td>
      mS-SQL-CreationDate
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591222
    </td>
    
    <td>
      mS-SQL-LastBackupDate
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591223
    </td>
    
    <td>
      mS-SQL-LastDiagnosticDate
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591224
    </td>
    
    <td>
      mS-SQL-Applications
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591225
    </td>
    
    <td>
      mS-SQL-Keywords
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591226
    </td>
    
    <td>
      mS-SQL-Publisher
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591227
    </td>
    
    <td>
      mS-SQL-AllowKnownPullSubscription
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591228
    </td>
    
    <td>
      mS-SQL-AllowImmediateUpdatingSubscription
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591229
    </td>
    
    <td>
      mS-SQL-AllowQueuedUpdatingSubscription
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591230
    </td>
    
    <td>
      mS-SQL-AllowSnapshotFilesFTPDownloading
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591231
    </td>
    
    <td>
      mS-SQL-ThirdParty
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTh591232
    </td>
    
    <td>
      mS-DS-ReplicatesNCReason
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTr591234
    </td>
    
    <td>
      mS-DS-CreatorSID
    </td>
    
    <td>
      INDEX_00090582
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591235
    </td>
    
    <td>
      ms-DS-MachineAccountQuota
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591238
    </td>
    
    <td>
      dNSTombstoned
    </td>
    
    <td>
      INDEX_00090586
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591239
    </td>
    
    <td>
      mSMQLabelEx
    </td>
    
    <td>
      INDEX_00090587
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591240
    </td>
    
    <td>
      mSMQSiteNameEx
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591241
    </td>
    
    <td>
      mSMQComputerTypeEx
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb591251
    </td>
    
    <td>
      msCOM-DefaultPartitionLink
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591252
    </td>
    
    <td>
      msCOM-ObjectId
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591253
    </td>
    
    <td>
      msPKI-RA-Signature
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591254
    </td>
    
    <td>
      msPKI-Enrollment-Flag
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591255
    </td>
    
    <td>
      msPKI-Private-Key-Flag
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591256
    </td>
    
    <td>
      msPKI-Certificate-Name-Flag
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591257
    </td>
    
    <td>
      msPKI-Minimal-Key-Size
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591258
    </td>
    
    <td>
      msPKI-Template-Schema-Version
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591259
    </td>
    
    <td>
      msPKI-Template-Minor-Revision
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591260
    </td>
    
    <td>
      msPKI-Cert-Template-OID
    </td>
    
    <td>
      INDEX_0009059C
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591261
    </td>
    
    <td>
      msPKI-Supersede-Templates
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591262
    </td>
    
    <td>
      msPKI-RA-Policies
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591263
    </td>
    
    <td>
      msPKI-Certificate-Policy
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591264
    </td>
    
    <td>
      msDs-Schema-Extensions
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591265
    </td>
    
    <td>
      msDS-Cached-Membership
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591266
    </td>
    
    <td>
      msDS-Cached-Membership-Time-Stamp
    </td>
    
    <td>
      INDEX_000905A2
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591267
    </td>
    
    <td>
      msDS-Site-Affinity
    </td>
    
    <td>
      INDEX_000905A3
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb591268
    </td>
    
    <td>
      msDS-Preferred-GC-Site
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591283
    </td>
    
    <td>
      msDS-Behavior-Version
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591445
    </td>
    
    <td>
      msDS-Other-Settings
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTl591446
    </td>
    
    <td>
      msDS-Entry-Time-To-Die
    </td>
    
    <td>
      INDEX_00090656
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591447
    </td>
    
    <td>
      msWMI-Author
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591448
    </td>
    
    <td>
      msWMI-ChangeDate
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591449
    </td>
    
    <td>
      msWMI-ClassDefinition
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591450
    </td>
    
    <td>
      msWMI-CreationDate
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591451
    </td>
    
    <td>
      msWMI-ID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591452
    </td>
    
    <td>
      msWMI-IntDefault
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591453
    </td>
    
    <td>
      msWMI-IntMax
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591454
    </td>
    
    <td>
      msWMI-IntMin
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591455
    </td>
    
    <td>
      msWMI-IntValidValues
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591456
    </td>
    
    <td>
      msWMI-Int8Default
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591457
    </td>
    
    <td>
      msWMI-Int8Max
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591458
    </td>
    
    <td>
      msWMI-Int8Min
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591459
    </td>
    
    <td>
      msWMI-Int8ValidValues
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591460
    </td>
    
    <td>
      msWMI-StringDefault
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591461
    </td>
    
    <td>
      msWMI-StringValidValues
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591462
    </td>
    
    <td>
      msWMI-Mof
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591463
    </td>
    
    <td>
      msWMI-Name
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591464
    </td>
    
    <td>
      msWMI-NormalizedClass
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591465
    </td>
    
    <td>
      msWMI-PropertyName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591466
    </td>
    
    <td>
      msWMI-Query
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591467
    </td>
    
    <td>
      msWMI-QueryLanguage
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591468
    </td>
    
    <td>
      msWMI-SourceOrganization
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591469
    </td>
    
    <td>
      msWMI-TargetClass
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591470
    </td>
    
    <td>
      msWMI-TargetNameSpace
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591471
    </td>
    
    <td>
      msWMI-TargetObject
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591472
    </td>
    
    <td>
      msWMI-TargetPath
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591473
    </td>
    
    <td>
      msWMI-TargetType
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591487
    </td>
    
    <td>
      msDS-Replication-Notify-First-DSA-Delay
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591488
    </td>
    
    <td>
      msDS-Replication-Notify-Subsequent-DSA-Delay
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591495
    </td>
    
    <td>
      msPKI-OID-Attribute
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591496
    </td>
    
    <td>
      msPKI-OID-CPS
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591497
    </td>
    
    <td>
      msPKI-OID-User-Notice
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591498
    </td>
    
    <td>
      msPKI-Certificate-Application-Policy
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591499
    </td>
    
    <td>
      msPKI-RA-Application-Policies
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591500
    </td>
    
    <td>
      msWMI-Class
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591501
    </td>
    
    <td>
      msWMI-Genus
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591502
    </td>
    
    <td>
      msWMI-intFlags1
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591503
    </td>
    
    <td>
      msWMI-intFlags2
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591504
    </td>
    
    <td>
      msWMI-intFlags3
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591505
    </td>
    
    <td>
      msWMI-intFlags4
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591506
    </td>
    
    <td>
      msWMI-Parm1
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591507
    </td>
    
    <td>
      msWMI-Parm2
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591508
    </td>
    
    <td>
      msWMI-Parm3
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591509
    </td>
    
    <td>
      msWMI-Parm4
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591510
    </td>
    
    <td>
      msWMI-ScopeGuid
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591511
    </td>
    
    <td>
      extraColumns
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591512
    </td>
    
    <td>
      msDS-Security-Group-Extra-Classes
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591513
    </td>
    
    <td>
      msDS-Non-Security-Group-Extra-Classes
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591514
    </td>
    
    <td>
      adminMultiselectPropertyPages
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591516
    </td>
    
    <td>
      msFRS-Topology-Pref
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591518
    </td>
    
    <td>
      gPCWQLFilter
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591519
    </td>
    
    <td>
      msMQ-Recipient-FormatName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591520
    </td>
    
    <td>
      lastLogonTimestamp
    </td>
    
    <td>
      INDEX_000906A0
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591521
    </td>
    
    <td>
      msDS-Settings
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591522
    </td>
    
    <td>
      msTAPI-uid
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591523
    </td>
    
    <td>
      msTAPI-ProtocolId
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591524
    </td>
    
    <td>
      msTAPI-ConferenceBlob
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591525
    </td>
    
    <td>
      msTAPI-IpAddress
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591526
    </td>
    
    <td>
      msDS-TrustForestTrustInfo
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591527
    </td>
    
    <td>
      msDS-FilterContainers
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591534
    </td>
    
    <td>
      msDS-AllowedDNSSuffixes
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591536
    </td>
    
    <td>
      msPKI-OIDLocalizedName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591537
    </td>
    
    <td>
      MSMQ-SecuredSource
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591538
    </td>
    
    <td>
      MSMQ-MulticastAddress
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591539
    </td>
    
    <td>
      msDS-SPNSuffixes
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591540
    </td>
    
    <td>
      msDS-IntId
    </td>
    
    <td>
      INDEX_000906B4
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591541
    </td>
    
    <td>
      msDS-AdditionalDnsHostName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591542
    </td>
    
    <td>
      msDS-AdditionalSamAccountName
    </td>
    
    <td>
      INDEX_000906B6
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591543
    </td>
    
    <td>
      msDS-DnsRootAlias
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591544
    </td>
    
    <td>
      msDS-ReplicationEpoch
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591545
    </td>
    
    <td>
      msDS-UpdateScript
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591604
    </td>
    
    <td>
      hideFromAB
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591607
    </td>
    
    <td>
      msDS-ExecuteScriptPassword
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591608
    </td>
    
    <td>
      msDS-LogonTimeSyncInterval
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591609
    </td>
    
    <td>
      msIIS-FTPRoot
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591610
    </td>
    
    <td>
      msIIS-FTPDir
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591611
    </td>
    
    <td>
      msDS-AllowedToDelegateTo
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591612
    </td>
    
    <td>
      msDS-PerUserTrustQuota
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591613
    </td>
    
    <td>
      msDS-AllUsersTrustQuota
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591614
    </td>
    
    <td>
      msDS-PerUserTrustTombstonesQuota
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591616
    </td>
    
    <td>
      msDS-AzLDAPQuery
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591619
    </td>
    
    <td>
      msDS-AzDomainTimeout
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591620
    </td>
    
    <td>
      msDS-AzScriptEngineCacheMax
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591621
    </td>
    
    <td>
      msDS-AzScriptTimeout
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591622
    </td>
    
    <td>
      msDS-AzApplicationName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591623
    </td>
    
    <td>
      msDS-AzScopeName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591624
    </td>
    
    <td>
      msDS-AzOperationID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591625
    </td>
    
    <td>
      msDS-AzBizRule
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591626
    </td>
    
    <td>
      msDS-AzBizRuleLanguage
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591627
    </td>
    
    <td>
      msDS-AzLastImportedBizRulePath
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591629
    </td>
    
    <td>
      msDS-AzGenerateAudits
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591640
    </td>
    
    <td>
      msDS-AzClassId
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591641
    </td>
    
    <td>
      msDS-AzApplicationVersion
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591642
    </td>
    
    <td>
      msDS-AzTaskIsRoleDefinition
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591643
    </td>
    
    <td>
      msDS-AzApplicationData
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591645
    </td>
    
    <td>
      msieee80211-Data
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591646
    </td>
    
    <td>
      msieee80211-DataType
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591647
    </td>
    
    <td>
      msieee80211-ID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591648
    </td>
    
    <td>
      msDS-AzMajorVersion
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591649
    </td>
    
    <td>
      msDS-AzMinorVersion
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591650
    </td>
    
    <td>
      msDS-RetiredReplNCSignatures
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591655
    </td>
    
    <td>
      msDS-ByteArray
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTl591656
    </td>
    
    <td>
      msDS-DateTime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591657
    </td>
    
    <td>
      msDS-ExternalKey
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591658
    </td>
    
    <td>
      msDS-ExternalStore
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591659
    </td>
    
    <td>
      msDS-Integer
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591666
    </td>
    
    <td>
      msDs-MaxValues
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591667
    </td>
    
    <td>
      msDRM-IdentityCertificate
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTr591668
    </td>
    
    <td>
      msDS-QuotaTrustee
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591669
    </td>
    
    <td>
      msDS-QuotaAmount
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591670
    </td>
    
    <td>
      msDS-DefaultQuota
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591671
    </td>
    
    <td>
      msDS-TombstoneQuotaFactor
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591703
    </td>
    
    <td>
      msDS-SourceObjectDN
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591716
    </td>
    
    <td>
      msPKIRoamingTimeStamp
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591734
    </td>
    
    <td>
      unixUserPassword
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf591737
    </td>
    
    <td>
      msRADIUS-FramedInterfaceId
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf591738
    </td>
    
    <td>
      msRADIUS-SavedFramedInterfaceId
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf591739
    </td>
    
    <td>
      msRADIUS-FramedIpv6Prefix
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf591740
    </td>
    
    <td>
      msRADIUS-SavedFramedIpv6Prefix
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf591741
    </td>
    
    <td>
      msRADIUS-FramedIpv6Route
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf591742
    </td>
    
    <td>
      msRADIUS-SavedFramedIpv6Route
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591753
    </td>
    
    <td>
      msDS-SecondaryKrbTgtNumber
    </td>
    
    <td>
      INDEX_00090789
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591766
    </td>
    
    <td>
      msDS-PhoneticFirstName
    </td>
    
    <td>
      INDEX_00090796
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591767
    </td>
    
    <td>
      msDS-PhoneticLastName
    </td>
    
    <td>
      INDEX_00090797
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591768
    </td>
    
    <td>
      msDS-PhoneticDepartment
    </td>
    
    <td>
      INDEX_00090798
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591769
    </td>
    
    <td>
      msDS-PhoneticCompanyName
    </td>
    
    <td>
      INDEX_00090799
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591770
    </td>
    
    <td>
      msDS-PhoneticDisplayName
    </td>
    
    <td>
      INDEX_0009079A
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591773
    </td>
    
    <td>
      msDS-AzObjectGuid
    </td>
    
    <td>
      INDEX_0009079D
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591774
    </td>
    
    <td>
      msDS-AzGenericData
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591775
    </td>
    
    <td>
      ms-net-ieee-80211-GP-PolicyGUID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591776
    </td>
    
    <td>
      ms-net-ieee-80211-GP-PolicyData
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591777
    </td>
    
    <td>
      ms-net-ieee-80211-GP-PolicyReserved
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591778
    </td>
    
    <td>
      ms-net-ieee-8023-GP-PolicyGUID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591779
    </td>
    
    <td>
      ms-net-ieee-8023-GP-PolicyData
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591780
    </td>
    
    <td>
      ms-net-ieee-8023-GP-PolicyReserved
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591786
    </td>
    
    <td>
      msDS-PromotionSettings
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591787
    </td>
    
    <td>
      msDS-SupportedEncryptionTypes
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591788
    </td>
    
    <td>
      msFVE-RecoveryPassword
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591789
    </td>
    
    <td>
      msFVE-RecoveryGuid
    </td>
    
    <td>
      INDEX_000907AD
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591790
    </td>
    
    <td>
      msTPM-OwnerInformation
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591793
    </td>
    
    <td>
      samDomainUpdates
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591794
    </td>
    
    <td>
      msDS-LastSuccessfulInteractiveLogonTime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591795
    </td>
    
    <td>
      msDS-LastFailedInteractiveLogonTime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591796
    </td>
    
    <td>
      msDS-FailedInteractiveLogonCount
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591797
    </td>
    
    <td>
      msDS-FailedInteractiveLogonCountAtLastSuccessfulLogon
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591800
    </td>
    
    <td>
      msTSProfilePath
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591801
    </td>
    
    <td>
      msTSHomeDirectory
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591802
    </td>
    
    <td>
      msTSHomeDrive
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591803
    </td>
    
    <td>
      msTSAllowLogon
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591804
    </td>
    
    <td>
      msTSRemoteControl
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591805
    </td>
    
    <td>
      msTSMaxDisconnectionTime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591806
    </td>
    
    <td>
      msTSMaxConnectionTime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591807
    </td>
    
    <td>
      msTSMaxIdleTime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591808
    </td>
    
    <td>
      msTSReconnectionAction
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591809
    </td>
    
    <td>
      msTSBrokenConnectionAction
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591810
    </td>
    
    <td>
      msTSConnectClientDrives
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591811
    </td>
    
    <td>
      msTSConnectPrinterDrives
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591812
    </td>
    
    <td>
      msTSDefaultToMainPrinter
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591813
    </td>
    
    <td>
      msTSWorkDirectory
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591814
    </td>
    
    <td>
      msTSInitialProgram
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591815
    </td>
    
    <td>
      msTSProperty01
    </td>
    
    <td>
      INDEX_000907C7
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591816
    </td>
    
    <td>
      msTSProperty02
    </td>
    
    <td>
      INDEX_000907C8
    </td>
  </tr>
  
  <tr>
    <td>
      ATTl591817
    </td>
    
    <td>
      msTSExpireDate
    </td>
    
    <td>
      INDEX_000907C9
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591818
    </td>
    
    <td>
      msTSLicenseVersion
    </td>
    
    <td>
      INDEX_000907CA
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591819
    </td>
    
    <td>
      msTSManagingLS
    </td>
    
    <td>
      INDEX_000907CB
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591821
    </td>
    
    <td>
      msDS-HABSeniorityIndex
    </td>
    
    <td>
      INDEX_000907CD
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591822
    </td>
    
    <td>
      msFVE-VolumeGuid
    </td>
    
    <td>
      INDEX_000907CE
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591823
    </td>
    
    <td>
      msFVE-KeyPackage
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTl591824
    </td>
    
    <td>
      msTSExpireDate2
    </td>
    
    <td>
      INDEX_000907D0
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591825
    </td>
    
    <td>
      msTSLicenseVersion2
    </td>
    
    <td>
      INDEX_000907D1
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591826
    </td>
    
    <td>
      msTSManagingLS2
    </td>
    
    <td>
      INDEX_000907D2
    </td>
  </tr>
  
  <tr>
    <td>
      ATTl591827
    </td>
    
    <td>
      msTSExpireDate3
    </td>
    
    <td>
      INDEX_000907D3
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591828
    </td>
    
    <td>
      msTSLicenseVersion3
    </td>
    
    <td>
      INDEX_000907D4
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591829
    </td>
    
    <td>
      msTSManagingLS3
    </td>
    
    <td>
      INDEX_000907D5
    </td>
  </tr>
  
  <tr>
    <td>
      ATTl591830
    </td>
    
    <td>
      msTSExpireDate4
    </td>
    
    <td>
      INDEX_000907D6
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591831
    </td>
    
    <td>
      msTSLicenseVersion4
    </td>
    
    <td>
      INDEX_000907D7
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591832
    </td>
    
    <td>
      msTSManagingLS4
    </td>
    
    <td>
      INDEX_000907D8
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591833
    </td>
    
    <td>
      msTSLSProperty01
    </td>
    
    <td>
      INDEX_000907D9
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591834
    </td>
    
    <td>
      msTSLSProperty02
    </td>
    
    <td>
      INDEX_000907DA
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591835
    </td>
    
    <td>
      msDS-MaximumPasswordAge
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591836
    </td>
    
    <td>
      msDS-MinimumPasswordAge
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591837
    </td>
    
    <td>
      msDS-MinimumPasswordLength
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591838
    </td>
    
    <td>
      msDS-PasswordHistoryLength
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591839
    </td>
    
    <td>
      msDS-PasswordComplexityEnabled
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591840
    </td>
    
    <td>
      msDS-PasswordReversibleEncryptionEnabled
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591841
    </td>
    
    <td>
      msDS-LockoutObservationWindow
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591842
    </td>
    
    <td>
      msDS-LockoutDuration
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591843
    </td>
    
    <td>
      msDS-LockoutThreshold
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591847
    </td>
    
    <td>
      msDS-PasswordSettingsPrecedence
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591848
    </td>
    
    <td>
      msDS-NcType
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591854
    </td>
    
    <td>
      msDFS-SchemaMajorVersion
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591855
    </td>
    
    <td>
      msDFS-SchemaMinorVersion
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591856
    </td>
    
    <td>
      msDFS-GenerationGUIDv2
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591857
    </td>
    
    <td>
      msDFS-NamespaceIdentityGUIDv2
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTl591858
    </td>
    
    <td>
      msDFS-LastModifiedv2
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591859
    </td>
    
    <td>
      msDFS-Ttlv2
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591860
    </td>
    
    <td>
      msDFS-Commentv2
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591861
    </td>
    
    <td>
      msDFS-Propertiesv2
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591862
    </td>
    
    <td>
      msDFS-TargetListv2
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591863
    </td>
    
    <td>
      msDFS-LinkPathv2
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTp591864
    </td>
    
    <td>
      msDFS-LinkSecurityDescriptorv2
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591865
    </td>
    
    <td>
      msDFS-LinkIdentityGUIDv2
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591866
    </td>
    
    <td>
      msDFS-ShortNameLinkPathv2
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591877
    </td>
    
    <td>
      msImaging-PSPIdentifier
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591878
    </td>
    
    <td>
      msImaging-PSPString
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591879
    </td>
    
    <td>
      msDS-USNLastSyncSuccess
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591882
    </td>
    
    <td>
      isRecycled
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591886
    </td>
    
    <td>
      msDS-OptionalFeatureGUID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591887
    </td>
    
    <td>
      msDS-OptionalFeatureFlags
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591890
    </td>
    
    <td>
      msDS-RequiredDomainBehaviorVersion
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591891
    </td>
    
    <td>
      msDS-LastKnownRDN
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591892
    </td>
    
    <td>
      msDS-DeletedObjectLifetime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591894
    </td>
    
    <td>
      msTSEndpointData
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591895
    </td>
    
    <td>
      msTSEndpointType
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591896
    </td>
    
    <td>
      msTSEndpointPlugin
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591900
    </td>
    
    <td>
      msPKI-Enrollment-Servers
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591901
    </td>
    
    <td>
      msPKI-Site-Name
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591903
    </td>
    
    <td>
      msDS-RequiredForestBehaviorVersion
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591905
    </td>
    
    <td>
      msSPP-CSVLKSkuId
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591906
    </td>
    
    <td>
      msSPP-KMSIds
    </td>
    
    <td>
      INDEX_00090822
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591907
    </td>
    
    <td>
      msSPP-InstallationId
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591908
    </td>
    
    <td>
      msSPP-ConfirmationId
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591909
    </td>
    
    <td>
      msSPP-OnlineLicense
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591910
    </td>
    
    <td>
      msSPP-PhoneLicense
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591911
    </td>
    
    <td>
      msSPP-ConfigLicense
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591912
    </td>
    
    <td>
      msSPP-IssuanceLicense
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591919
    </td>
    
    <td>
      msDS-IsUsedAsResourceSecurityAttribute
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591921
    </td>
    
    <td>
      msDS-ClaimPossibleValues
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq591922
    </td>
    
    <td>
      msDS-ClaimValueType
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb591923
    </td>
    
    <td>
      msDS-ClaimAttributeSource
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591929
    </td>
    
    <td>
      msSPP-CSVLKPid
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591930
    </td>
    
    <td>
      msSPP-CSVLKPartialProductKey
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591931
    </td>
    
    <td>
      msTPM-SrkPubThumbprint
    </td>
    
    <td>
      INDEX_0009083B
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591932
    </td>
    
    <td>
      msTPM-OwnerInformationTemp
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591952
    </td>
    
    <td>
      msDNS-KeymasterZones
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591954
    </td>
    
    <td>
      msDNS-IsSigned
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591955
    </td>
    
    <td>
      msDNS-SignWithNSEC3
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591956
    </td>
    
    <td>
      msDNS-NSEC3OptOut
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591957
    </td>
    
    <td>
      msDNS-MaintainTrustAnchor
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591958
    </td>
    
    <td>
      msDNS-DSRecordAlgorithms
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591959
    </td>
    
    <td>
      msDNS-RFC5011KeyRollovers
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591960
    </td>
    
    <td>
      msDNS-NSEC3HashAlgorithm
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591961
    </td>
    
    <td>
      msDNS-NSEC3RandomSaltLength
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591962
    </td>
    
    <td>
      msDNS-NSEC3Iterations
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591963
    </td>
    
    <td>
      msDNS-DNSKEYRecordSetTTL
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591964
    </td>
    
    <td>
      msDNS-DSRecordSetTTL
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591965
    </td>
    
    <td>
      msDNS-SignatureInceptionOffset
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591966
    </td>
    
    <td>
      msDNS-SecureDelegationPollingPeriod
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591967
    </td>
    
    <td>
      msDNS-SigningKeyDescriptors
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591968
    </td>
    
    <td>
      msDNS-SigningKeys
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591969
    </td>
    
    <td>
      msDNS-DNSKEYRecords
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591970
    </td>
    
    <td>
      msDNS-ParentHasSecureDelegation
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591971
    </td>
    
    <td>
      msDNS-PropagationTime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591972
    </td>
    
    <td>
      msDNS-NSEC3UserSalt
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591973
    </td>
    
    <td>
      msDNS-NSEC3CurrentSalt
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591974
    </td>
    
    <td>
      msAuthz-EffectiveSecurityPolicy
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591975
    </td>
    
    <td>
      msAuthz-ProposedSecurityPolicy
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591976
    </td>
    
    <td>
      msAuthz-LastEffectiveSecurityPolicy
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591977
    </td>
    
    <td>
      msAuthz-ResourceCondition
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTr591978
    </td>
    
    <td>
      msAuthz-CentralAccessPolicyID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591981
    </td>
    
    <td>
      msDS-ClaimSource
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591982
    </td>
    
    <td>
      msDS-ClaimSourceType
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591983
    </td>
    
    <td>
      msDS-ClaimIsValueSpaceRestricted
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi591984
    </td>
    
    <td>
      msDS-ClaimIsSingleValued
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591990
    </td>
    
    <td>
      msDS-GenerationId
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591993
    </td>
    
    <td>
      msKds-KDFAlgorithmID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591994
    </td>
    
    <td>
      msKds-KDFParam
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm591995
    </td>
    
    <td>
      msKds-SecretAgreementAlgorithmID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591996
    </td>
    
    <td>
      msKds-SecretAgreementParam
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591997
    </td>
    
    <td>
      msKds-PublicKeyLength
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj591998
    </td>
    
    <td>
      msKds-PrivateKeyLength
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk591999
    </td>
    
    <td>
      msKds-RootKeyData
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj592000
    </td>
    
    <td>
      msKds-Version
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb592001
    </td>
    
    <td>
      msKds-DomainID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq592002
    </td>
    
    <td>
      msKds-UseStartTime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq592003
    </td>
    
    <td>
      msKds-CreateTime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk592004
    </td>
    
    <td>
      msImaging-ThumbprintHash
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592005
    </td>
    
    <td>
      msImaging-HashAlgorithm
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTp592006
    </td>
    
    <td>
      msDS-AllowedToActOnBehalfOfOtherIdentity
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq592007
    </td>
    
    <td>
      msDS-GeoCoordinatesAltitude
    </td>
    
    <td>
      INDEX_00090887
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq592008
    </td>
    
    <td>
      msDS-GeoCoordinatesLatitude
    </td>
    
    <td>
      INDEX_00090888
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq592009
    </td>
    
    <td>
      msDS-GeoCoordinatesLongitude
    </td>
    
    <td>
      INDEX_00090889
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi592010
    </td>
    
    <td>
      msDS-IsPossibleValuesPresent
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592013
    </td>
    
    <td>
      msDS-TransformationRules
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk592014
    </td>
    
    <td>
      msDS-TransformationRulesCompiled
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592019
    </td>
    
    <td>
      msDS-AppliesToResourceTypes
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk592021
    </td>
    
    <td>
      msDS-ManagedPasswordId
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk592022
    </td>
    
    <td>
      msDS-ManagedPasswordPreviousId
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj592023
    </td>
    
    <td>
      msDS-ManagedPasswordInterval
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTp592024
    </td>
    
    <td>
      msDS-GroupMSAMembership
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi592037
    </td>
    
    <td>
      msDS-RIDPoolAllocationEnabled
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592038
    </td>
    
    <td>
      msDS-cloudExtensionAttribute1
    </td>
    
    <td>
      INDEX_000908A6
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592039
    </td>
    
    <td>
      msDS-cloudExtensionAttribute2
    </td>
    
    <td>
      INDEX_000908A7
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592040
    </td>
    
    <td>
      msDS-cloudExtensionAttribute3
    </td>
    
    <td>
      INDEX_000908A8
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592041
    </td>
    
    <td>
      msDS-cloudExtensionAttribute4
    </td>
    
    <td>
      INDEX_000908A9
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592042
    </td>
    
    <td>
      msDS-cloudExtensionAttribute5
    </td>
    
    <td>
      INDEX_000908AA
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592043
    </td>
    
    <td>
      msDS-cloudExtensionAttribute6
    </td>
    
    <td>
      INDEX_000908AB
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592044
    </td>
    
    <td>
      msDS-cloudExtensionAttribute7
    </td>
    
    <td>
      INDEX_000908AC
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592045
    </td>
    
    <td>
      msDS-cloudExtensionAttribute8
    </td>
    
    <td>
      INDEX_000908AD
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592046
    </td>
    
    <td>
      msDS-cloudExtensionAttribute9
    </td>
    
    <td>
      INDEX_000908AE
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592047
    </td>
    
    <td>
      msDS-cloudExtensionAttribute10
    </td>
    
    <td>
      INDEX_000908AF
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592048
    </td>
    
    <td>
      msDS-cloudExtensionAttribute11
    </td>
    
    <td>
      INDEX_000908B0
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592049
    </td>
    
    <td>
      msDS-cloudExtensionAttribute12
    </td>
    
    <td>
      INDEX_000908B1
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592050
    </td>
    
    <td>
      msDS-cloudExtensionAttribute13
    </td>
    
    <td>
      INDEX_000908B2
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592051
    </td>
    
    <td>
      msDS-cloudExtensionAttribute14
    </td>
    
    <td>
      INDEX_000908B3
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592052
    </td>
    
    <td>
      msDS-cloudExtensionAttribute15
    </td>
    
    <td>
      INDEX_000908B4
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592053
    </td>
    
    <td>
      msDS-cloudExtensionAttribute16
    </td>
    
    <td>
      INDEX_000908B5
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592054
    </td>
    
    <td>
      msDS-cloudExtensionAttribute17
    </td>
    
    <td>
      INDEX_000908B6
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592055
    </td>
    
    <td>
      msDS-cloudExtensionAttribute18
    </td>
    
    <td>
      INDEX_000908B7
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592056
    </td>
    
    <td>
      msDS-cloudExtensionAttribute19
    </td>
    
    <td>
      INDEX_000908B8
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592057
    </td>
    
    <td>
      msDS-cloudExtensionAttribute20
    </td>
    
    <td>
      INDEX_000908B9
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk592058
    </td>
    
    <td>
      netbootDUID
    </td>
    
    <td>
      INDEX_000908BA
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk592064
    </td>
    
    <td>
      msDS-IssuerCertificates
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj592065
    </td>
    
    <td>
      msDS-RegistrationQuota
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj592066
    </td>
    
    <td>
      msDS-MaximumRegistrationInactivityPeriod
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi592072
    </td>
    
    <td>
      msDS-IsEnabled
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592073
    </td>
    
    <td>
      msDS-DeviceOSType
    </td>
    
    <td>
      INDEX_000908C9
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592074
    </td>
    
    <td>
      msDS-DeviceOSVersion
    </td>
    
    <td>
      INDEX_000908CA
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592075
    </td>
    
    <td>
      msDS-DevicePhysicalIDs
    </td>
    
    <td>
      INDEX_000908CB
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk592076
    </td>
    
    <td>
      msDS-DeviceID
    </td>
    
    <td>
      INDEX_000908CC
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj592081
    </td>
    
    <td>
      msDS-DeviceObjectVersion
    </td>
    
    <td>
      INDEX_000908D1
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk592082
    </td>
    
    <td>
      msDS-RegisteredOwner
    </td>
    
    <td>
      INDEX_000908D2
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb592085
    </td>
    
    <td>
      msDS-DeviceLocation
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq592086
    </td>
    
    <td>
      msDS-ApproximateLastLogonTimeStamp
    </td>
    
    <td>
      INDEX_000908D6
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk592087
    </td>
    
    <td>
      msDS-RegisteredUsers
    </td>
    
    <td>
      INDEX_000908D7
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592089
    </td>
    
    <td>
      msDS-DrsFarmID
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk592093
    </td>
    
    <td>
      msDS-IssuerPublicCertificates
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi592094
    </td>
    
    <td>
      msDS-IsManaged
    </td>
    
    <td>
      INDEX_000908DE
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi592095
    </td>
    
    <td>
      msDS-CloudIsManaged
    </td>
    
    <td>
      INDEX_000908DF
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk592097
    </td>
    
    <td>
      msDS-CloudAnchor
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk592098
    </td>
    
    <td>
      msDS-CloudIssuerPublicCertificates
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi592099
    </td>
    
    <td>
      msDS-CloudIsEnabled
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm592100
    </td>
    
    <td>
      msDS-SyncServerUrl
    </td>
    
    <td>
      INDEX_000908E4
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk592101
    </td>
    
    <td>
      msDS-UserAllowedToAuthenticateTo
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk592102
    </td>
    
    <td>
      msDS-UserAllowedToAuthenticateFrom
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq592103
    </td>
    
    <td>
      msDS-UserTGTLifetime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk592104
    </td>
    
    <td>
      msDS-ComputerAllowedToAuthenticateTo
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq592105
    </td>
    
    <td>
      msDS-ComputerTGTLifetime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk592106
    </td>
    
    <td>
      msDS-ServiceAllowedToAuthenticateTo
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk592107
    </td>
    
    <td>
      msDS-ServiceAllowedToAuthenticateFrom
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq592108
    </td>
    
    <td>
      msDS-ServiceTGTLifetime
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi592121
    </td>
    
    <td>
      msDS-AuthNPolicyEnforced
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi592122
    </td>
    
    <td>
      msDS-AuthNPolicySiloEnforced
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk1310860
    </td>
    
    <td>
      userSMIMECertificate
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1376257
    </td>
    
    <td>
      uid
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1376258
    </td>
    
    <td>
      textEncodedORAddress
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1376259
    </td>
    
    <td>
      mail
    </td>
    
    <td>
      INDEX_00150003
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1376261
    </td>
    
    <td>
      drink
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1376262
    </td>
    
    <td>
      roomNumber
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk1376263
    </td>
    
    <td>
      photo
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1376264
    </td>
    
    <td>
      userClass
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1376265
    </td>
    
    <td>
      host
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1376267
    </td>
    
    <td>
      documentIdentifier
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1376268
    </td>
    
    <td>
      documentTitle
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1376269
    </td>
    
    <td>
      documentVersion
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb1376270
    </td>
    
    <td>
      documentAuthor
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1376271
    </td>
    
    <td>
      documentLocation
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1376276
    </td>
    
    <td>
      homePhone
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb1376277
    </td>
    
    <td>
      secretary
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1376281
    </td>
    
    <td>
      dc
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf1376293
    </td>
    
    <td>
      associatedDomain
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTb1376294
    </td>
    
    <td>
      associatedName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1376297
    </td>
    
    <td>
      mobile
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1376298
    </td>
    
    <td>
      pager
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1376300
    </td>
    
    <td>
      uniqueIdentifier
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1376301
    </td>
    
    <td>
      organizationalStatus
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1376304
    </td>
    
    <td>
      buildingName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk1376311
    </td>
    
    <td>
      audio
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1376312
    </td>
    
    <td>
      documentPublisher
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk1376316
    </td>
    
    <td>
      jpegPhoto
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1441793
    </td>
    
    <td>
      carLicense
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1441794
    </td>
    
    <td>
      departmentNumber
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1441826
    </td>
    
    <td>
      middleName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk1441827
    </td>
    
    <td>
      thumbnailPhoto
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk1441828
    </td>
    
    <td>
      thumbnailLogo
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1441831
    </td>
    
    <td>
      preferredLanguage
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk1442008
    </td>
    
    <td>
      userPKCS12
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1900601
    </td>
    
    <td>
      labeledURI
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf1966082
    </td>
    
    <td>
      unstructuredName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm1966088
    </td>
    
    <td>
      unstructuredAddress
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm2162988
    </td>
    
    <td>
      msSFU30SearchContainer
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm2162989
    </td>
    
    <td>
      msSFU30KeyAttributes
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm2162990
    </td>
    
    <td>
      msSFU30FieldSeparator
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm2162991
    </td>
    
    <td>
      msSFU30IntraFieldSeparator
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm2162992
    </td>
    
    <td>
      msSFU30SearchAttributes
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm2162993
    </td>
    
    <td>
      msSFU30ResultAttributes
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm2162994
    </td>
    
    <td>
      msSFU30MapFilter
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm2162995
    </td>
    
    <td>
      msSFU30MasterServerName
    </td>
    
    <td>
      INDEX_00210133
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm2162996
    </td>
    
    <td>
      msSFU30OrderNumber
    </td>
    
    <td>
      INDEX_00210134
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2162997
    </td>
    
    <td>
      msSFU30Name
    </td>
    
    <td>
      INDEX_00210135
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2163011
    </td>
    
    <td>
      msSFU30Aliases
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2163012
    </td>
    
    <td>
      msSFU30KeyValues
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2163027
    </td>
    
    <td>
      msSFU30NisDomain
    </td>
    
    <td>
      INDEX_00210153
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2163028
    </td>
    
    <td>
      msSFU30Domains
    </td>
    
    <td>
      INDEX_00210154
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2163029
    </td>
    
    <td>
      msSFU30YpServers
    </td>
    
    <td>
      INDEX_00210155
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2163030
    </td>
    
    <td>
      msSFU30MaxGidNumber
    </td>
    
    <td>
      INDEX_00210156
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2163031
    </td>
    
    <td>
      msSFU30MaxUidNumber
    </td>
    
    <td>
      INDEX_00210157
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2163033
    </td>
    
    <td>
      msSFU30NSMAPFieldPosition
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2163036
    </td>
    
    <td>
      msSFU30NetgroupHostAtDomain
    </td>
    
    <td>
      INDEX_0021015C
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2163037
    </td>
    
    <td>
      msSFU30NetgroupUserAtDomain
    </td>
    
    <td>
      INDEX_0021015D
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2163038
    </td>
    
    <td>
      msSFU30IsValidContainer
    </td>
    
    <td>
      INDEX_0021015E
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2163040
    </td>
    
    <td>
      msSFU30CryptMethod
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm2293761
    </td>
    
    <td>
      msDFSR-Version
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk2293762
    </td>
    
    <td>
      msDFSR-Extension
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm2293763
    </td>
    
    <td>
      msDFSR-RootPath
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq2293764
    </td>
    
    <td>
      msDFSR-RootSizeInMb
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm2293765
    </td>
    
    <td>
      msDFSR-StagingPath
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq2293766
    </td>
    
    <td>
      msDFSR-StagingSizeInMb
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm2293767
    </td>
    
    <td>
      msDFSR-ConflictPath
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq2293768
    </td>
    
    <td>
      msDFSR-ConflictSizeInMb
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi2293769
    </td>
    
    <td>
      msDFSR-Enabled
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2293770
    </td>
    
    <td>
      msDFSR-ReplicationGroupType
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2293771
    </td>
    
    <td>
      msDFSR-TombstoneExpiryInMin
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm2293772
    </td>
    
    <td>
      msDFSR-FileFilter
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm2293773
    </td>
    
    <td>
      msDFSR-DirectoryFilter
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk2293774
    </td>
    
    <td>
      msDFSR-Schedule
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm2293775
    </td>
    
    <td>
      msDFSR-Keywords
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2293776
    </td>
    
    <td>
      msDFSR-Flags
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2293777
    </td>
    
    <td>
      msDFSR-Options
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk2293778
    </td>
    
    <td>
      msDFSR-ContentSetGuid
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi2293779
    </td>
    
    <td>
      msDFSR-RdcEnabled
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq2293780
    </td>
    
    <td>
      msDFSR-RdcMinFileSizeInKb
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm2293781
    </td>
    
    <td>
      msDFSR-DfsPath
    </td>
    
    <td>
      INDEX_00230015
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2293782
    </td>
    
    <td>
      msDFSR-RootFence
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTk2293783
    </td>
    
    <td>
      msDFSR-ReplicationGroupGuid
    </td>
    
    <td>
      INDEX_00230017
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm2293784
    </td>
    
    <td>
      msDFSR-DfsLinkTarget
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2293785
    </td>
    
    <td>
      msDFSR-Priority
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm2293786
    </td>
    
    <td>
      msDFSR-DeletedPath
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq2293787
    </td>
    
    <td>
      msDFSR-DeletedSizeInMb
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi2293788
    </td>
    
    <td>
      msDFSR-ReadOnly
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2293789
    </td>
    
    <td>
      msDFSR-CachePolicy
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2293790
    </td>
    
    <td>
      msDFSR-MinDurationCacheInMin
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2293791
    </td>
    
    <td>
      msDFSR-MaxAgeInCacheInMin
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTi2293792
    </td>
    
    <td>
      msDFSR-DisablePacketPrivacy
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm2293794
    </td>
    
    <td>
      msDFSR-DefaultCompressionExclusionFilter
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm2293795
    </td>
    
    <td>
      msDFSR-OnDemandExclusionFileFilter
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm2293796
    </td>
    
    <td>
      msDFSR-OnDemandExclusionDirectoryFilter
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2293797
    </td>
    
    <td>
      msDFSR-Options2
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTm2293798
    </td>
    
    <td>
      msDFSR-CommonStagingPath
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTq2293799
    </td>
    
    <td>
      msDFSR-CommonStagingSizeInMb
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2293800
    </td>
    
    <td>
      msDFSR-StagingCleanupTriggerInPercent
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2424832
    </td>
    
    <td>
      uidNumber
    </td>
    
    <td>
      INDEX_00250000
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2424833
    </td>
    
    <td>
      gidNumber
    </td>
    
    <td>
      INDEX_00250001
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2424834
    </td>
    
    <td>
      gecos
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2424835
    </td>
    
    <td>
      unixHomeDirectory
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2424836
    </td>
    
    <td>
      loginShell
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2424837
    </td>
    
    <td>
      shadowLastChange
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2424838
    </td>
    
    <td>
      shadowMin
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2424839
    </td>
    
    <td>
      shadowMax
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2424840
    </td>
    
    <td>
      shadowWarning
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2424841
    </td>
    
    <td>
      shadowInactive
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2424842
    </td>
    
    <td>
      shadowExpire
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2424843
    </td>
    
    <td>
      shadowFlag
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2424844
    </td>
    
    <td>
      memberUid
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2424845
    </td>
    
    <td>
      memberNisNetgroup
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2424846
    </td>
    
    <td>
      nisNetgroupTriple
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2424847
    </td>
    
    <td>
      ipServicePort
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2424848
    </td>
    
    <td>
      ipServiceProtocol
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2424849
    </td>
    
    <td>
      ipProtocolNumber
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTj2424850
    </td>
    
    <td>
      oncRpcNumber
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2424851
    </td>
    
    <td>
      ipHostNumber
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2424852
    </td>
    
    <td>
      ipNetworkNumber
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2424853
    </td>
    
    <td>
      ipNetmaskNumber
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2424854
    </td>
    
    <td>
      macAddress
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2424855
    </td>
    
    <td>
      bootParameter
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2424856
    </td>
    
    <td>
      bootFile
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2424858
    </td>
    
    <td>
      nisMapName
    </td>
    
    <td>
    </td>
  </tr>
  
  <tr>
    <td>
      ATTf2424859
    </td>
    
    <td>
      nisMapEntry
    </td>
    
    <td>
    </td>
  </tr>
</table>