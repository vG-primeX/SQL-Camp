SELECT        [Document No_], Type, [Document Date], [Document Time], [Sell-to Customer No_], [Sell-to Customer Name], [Salesperson Code Nav], [Salesperson Code], [Internal No], [Active No], [Item Category], Quantity, 
                         [Unit Price], Amount, [Statistical Amount], [Chain Name], [Location Code], [Margin Amount], Volume, [Total Liters], [Line Discount %], [Manufacturer Code], [Manufacturer Name],[Volume Group]
FROM            (SELECT        base.[Document No_], base.Type, base.[Posting Date] AS [Document Date], base.Time AS [Document Time], base.[Sell-to Customer No_], c.Name AS [Sell-to Customer Name], 
                                                    CASE WHEN c.[Salesperson Code] = 'B22NMIHOV' THEN 'NMIHOV' WHEN c.[Salesperson Code] = 'MKIROVB15' THEN 'MKIROV' WHEN c.[Salesperson Code] = 'TSPASOVB31' THEN 'TSPASOV' WHEN
                                                     c.[Salesperson Code] = 'YDACHEVB23' THEN 'YDACHEV' WHEN c.[Salesperson Code] = 'ASTOYANOVB' THEN 'ASTOYANOV' WHEN c.[Salesperson Code] = 'DALEKSIEVB' THEN 'DALEKSIEV' WHEN c.[Salesperson Code]
                                                     = 'NIKPETROVB' THEN 'NIKPETROV' WHEN c.[Salesperson Code] = 'DKALOYANOB' THEN 'DKALOYANOV' WHEN c.[Salesperson Code] = 'HMILEVB23' THEN 'HMILEV' WHEN c.[Salesperson Code] = 'HMILEVV'
                                                     THEN 'HMILEV' WHEN c.[Salesperson Code] = 'IILIEVB26' THEN 'IILIEV' WHEN c.[Salesperson Code] = 'KPETKOVHUB' THEN 'KPETKOV' WHEN c.[Salesperson Code] = 'GIVANOVB14' THEN 'GIVANOV'
                                                     WHEN c.[Salesperson Code] = 'GIVANOVB22' THEN 'GIVANOV' WHEN c.[Salesperson Code] = 'GIVANOVB29' THEN 'GIVANOV' WHEN c.[Salesperson Code] = 'NIKPETROVB' THEN 'NIKPETROV' WHEN
                                                     c.[Salesperson Code] = 'MISUBCHEV' THEN 'MSABCHEV' WHEN c.[Salesperson Code] = 'VBALIEVB40' THEN 'VBALIEV' ELSE c.[Salesperson Code] END AS [Salesperson Code Nav], 
                                                    CASE WHEN Stat.[Salesperson Code] = 'B22NMIHOV' THEN 'NMIHOV' WHEN Stat.[Salesperson Code] = 'MKIROVB15' THEN 'MKIROV' WHEN Stat.[Salesperson Code] = 'TSPASOVB31' THEN 'TSPASOV'
                                                     WHEN Stat.[Salesperson Code] = 'YDACHEVB23' THEN 'YDACHEV' WHEN Stat.[Salesperson Code] = 'ASTOYANOVB' THEN 'ASTOYANOV' WHEN Stat.[Salesperson Code] = 'DALEKSIEVB' THEN 'DALEKSIEV'
                                                     WHEN Stat.[Salesperson Code] = 'NIKPETROVB' THEN 'NIKPETROV' WHEN Stat.[Salesperson Code] = 'DKALOYANOB' THEN 'DKALOYANOV' WHEN Stat.[Salesperson Code] = 'HMILEVB23' THEN 'HMILEV'
                                                     WHEN Stat.[Salesperson Code] = 'HMILEVV' THEN 'HMILEV' WHEN Stat.[Salesperson Code] = 'IILIEVB26' THEN 'IILIEV' WHEN Stat.[Salesperson Code] = 'KPETKOVHUB' THEN 'KPETKOV' WHEN Stat.[Salesperson Code]
                                                     = 'GIVANOVB14' THEN 'GIVANOV' WHEN Stat.[Salesperson Code] = 'GIVANOVB22' THEN 'GIVANOV' WHEN Stat.[Salesperson Code] = 'GIVANOVB29' THEN 'GIVANOV' WHEN Stat.[Salesperson Code] = 'NIKPETROVB'
                                                     THEN 'NIKPETROV' WHEN Stat.[Salesperson Code] = 'MISUBCHEV' THEN 'MSABCHEV' WHEN Stat.[Salesperson Code] = 'VBALIEVB40' THEN 'VBALIEV' ELSE Stat.[Salesperson Code] END AS [Salesperson Code],
                                                     base.No_ AS [Internal No], i.[No_ 2] AS [Active No], base.[Item Category], base.Quantity, base.[Unit Price], base.Amount, CAST(base.Quantity * i.[Statistical Price] AS decimal(10, 2)) 
                                                    AS [Statistical Amount], Stat.[Chain Name], base.[Location Code], base.Amount - base.Quantity * i.[Statistical Price] AS [Margin Amount], v.Volume, base.Quantity * v.Volume AS [Total Liters], 
                                                    base.[Line Discount %], m.Code AS [Manufacturer Code], m.Name AS [Manufacturer Name], groups.[BD GROUP] AS [Volume Group]
                          FROM            (SELECT        'Order' AS Type, CONVERT(date, [Entry DateTime]) AS [Posting Date], CONVERT(time(0), [Entry DateTime]) AS Time, [Document No_], [Sell-to Customer No_], No_, [Location Code], 
                                                                              [Item Category Code] AS [Item Category], CAST([Outstanding Quantity] AS decimal(10, 2)) AS Quantity, CAST([Unit Price] AS decimal(10, 2)) AS [Unit Price], 
                                                                              CAST([Line Discount _] AS decimal(10, 2)) AS [Line Discount %], CAST([Outstanding Amount] / 1.2 AS decimal(10, 2)) AS Amount
                                                    FROM            MDR.dbo.nav_BG$Sales_Line AS o WITH (NOLOCK)
                                                    WHERE        ([Document Type] = 1) AND (No_ <> '') AND ([Outstanding Quantity] > 0)
                                                    UNION ALL
                                                    SELECT        CASE WHEN SSL.Quantity > 0 THEN 'Shipment' ELSE 'Undo shipment' END AS Type, CONVERT(date, SSL.[Entry DateTime]) AS [Posting Date], CONVERT(time(0), SSL.[Entry DateTime]) 
                                                                             AS Time, CASE WHEN SIL.[Document No_] IS NULL THEN SSL.[Document No_] ELSE SIL.[Document No_] END AS [Document No_], SSL.[Sell-to Customer No_], SSL.No_, 
                                                                             SSL.[Location Code], SSL.[Item Category Code] AS [Item Category], CASE WHEN SIL.[Document No_] IS NULL THEN SSL.Quantity ELSE - SIL.Quantity END AS Quantity, SSL.[Unit Price], 
                                                                             CAST(SSL.[Line Discount _] AS decimal(10, 2)) AS [Line Discount %], CASE WHEN SIL.[Sales Amount (Actual)] IS NULL 
                                                                             THEN SSL.[Shipment Amount] ELSE SIL.[Sales Amount (Actual)] END AS [ Amount]
                                                    FROM            MDR.dbo.nav_BG$Sales_Shipment_Line AS SSL WITH (NOLOCK) LEFT OUTER JOIN
                                                                             MDR.dbo.nav_BG$Sales_Shipment_Header AS SSH WITH (NOLOCK) ON SSL.[Document No_] = SSH.No_ LEFT OUTER JOIN
                                                                                 (SELECT        [Document No_], [Invoiced Quantity] AS Quantity, [Item Ledger Entry No_], [Posting Date], [Sales Amount (Actual)]
                                                                                   FROM            MDR.dbo.nav_BG$Value_Entry AS ve WITH (NOLOCK)
                                                                                   WHERE        (Adjustment = '0') AND ([Document Type] = '2')) AS SIL ON SSL.[Item Shpt_ Entry No_] = SIL.[Item Ledger Entry No_]
                                                    UNION ALL
                                                    SELECT        'Credit Memo' AS Type, CONVERT(date, SSL.[Entry DateTime]) AS [Posting Date], CONVERT(time(0), SSL.[Entry DateTime]) AS Time, tCMLine.[Document No_], 
                                                                             tCMLine.[Sell-to Customer No_], tCMLine.No_, tCMLine.[Location Code], tCMLine.[Item Category Code] AS [Item Category], CAST(- tCMLine.Quantity AS decimal(10, 2)) AS Quantity, 
                                                                             CAST(tCMLine.[Unit Price] AS decimal(10, 2)) AS [Unit Price], CAST(tCMLine.[Line Discount _] AS decimal(10, 2)) AS [Line Discount %], 
                                                                             CAST(- (tCMLine.Quantity * ROUND(ROUND(ROUND(tCMLine.[Unit Price], 2) * (1 - tCMLine.[Line Discount _] / 100) + 0.0004, 3) - 0.001, 2)) AS decimal(10, 2)) AS Amount
                                                    FROM            MDR.dbo.nav_BG$Sales_Cr_Memo_Line AS tCMLine WITH (NOLOCK) LEFT OUTER JOIN
                                                                             MDR.dbo.nav_BG$Sales_Cr_Memo_Header AS tCMHeader WITH (NOLOCK) ON tCMLine.[Document No_] = tCMHeader.No_ LEFT OUTER JOIN
                                                                             MDR.dbo.nav_BG$Sales_Shipment_Line AS SSL WITH (NOLOCK) ON tCMLine.[Appl_-from Item Entry] = SSL.[Item Shpt_ Entry No_]
                                                    WHERE        (tCMLine.Type = 2)) AS base LEFT OUTER JOIN
                                                    MDR.dbo.nav_BG$Item AS i WITH (NOLOCK) ON base.No_ = i.No_ LEFT OUTER JOIN
                                                    MDR.dbo.nav_BG$Manufacturer AS m WITH (NOLOCK) ON i.[Manufacturer Code] = m.Code LEFT OUTER JOIN
                                                    MDR.dbo.nav_BG$Customer AS c WITH (NOLOCK) ON base.[Sell-to Customer No_] = c.No_ LEFT OUTER JOIN
                                                    dbo.MB_PM_Volumes AS v WITH (NOLOCK) ON base.No_ = v.Int_No LEFT OUTER JOIN
                                                    dbo.SD_OILS_CUSTOMER_SALESPERSON_LOCKED AS Stat WITH (NOLOCK) ON base.[Sell-to Customer No_] = Stat.No# LEFT OUTER JOIN
													[BGMDR].[dbo].[SD_OILS_CAMPAIGN_GROUPS] AS GROUPS WITH (NOLOCK) ON base.No_ = GROUPS.ItemNo
													
                          WHERE        (base.[Posting Date] BETWEEN '2022-05-09' AND '2022-05-31') 
						  AND ((m.Code IN ('185826','472279','002618','015538','471289','057014','808443','002645','505841','808435','808439','913363','732045','002680','015498','471280','012852','808430','002524','287059','472281','002506','015583','471288','505897','99SO7I'))  OR (m.Code IN ('019935','016240','019929') AND base.[Item Category] IN ('070101')))
						   AND (c.[Customer Group Code] NOT IN ('SZ0702')) 
						  ) AS B