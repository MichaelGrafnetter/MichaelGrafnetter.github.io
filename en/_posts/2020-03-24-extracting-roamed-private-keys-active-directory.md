---
id: 9685
title: 'Extracting Roamed Private Keys from&nbsp;Active Directory'
date: '2020-03-24T22:32:35+00:00'
author: 'Michael Grafnetter'
layout: post
guid: 'https://www.dsinternals.com/?p=9685'
permalink: /en/extracting-roamed-private-keys-active-directory/
categories:
    - Uncategorized
---

One of the lesser known features of Active Directory (AD) is called **Credential Roaming**. When enabled, it synchronizes DPAPI Master Keys, user certificates (including the corresponding private keys) and even saved passwords between computers. These credentials can easily be extracted from Active Directory database. If you want to learn more on this topic, be sure to read my [\#CQLabs article](https://cqureacademy.com/blog/extracting-roamed-private-keys).