<System.Serializable()> <Microsoft.VisualBasic.ComClass()> Public Class Pricing
    Public Function Process(ByVal Session As Object) As Boolean
        If Session.Transaction.InProgress = True Then
            If Session.Transaction.Customer.Loaded Then
                Dim CurrentCustomer = Session.Transaction.Customer
                Dim catalogs_needed = CurrentCustomer.CustomText2
                Dim catalogs_needed_length = catalogs_needed.Length
                'Dim test = "test"
                'MsgBox("catalogs_needed_length: " + catalogs_needed_length, vbOKOnly Or vbInformation, "Barbersystem")
                If catalogs_needed_length > 1 Then
                    MsgBox("Customer needs catalog. Please check and update customer card.", vbOKOnly Or vbInformation, "Barbersystem")
                End If

                If CurrentCustomer.PriceLevel = 1 Or CurrentCustomer.PriceLevel = 2 Or CurrentCustomer.PriceLevel = 3 Then
                    Session.Transaction.SetTaxable(0, 0)
                    Dim discount_type = "none"
                    Dim discount_multiple = 0.0
                    Dim discount_savings = 0.0
                    Dim online_discount_key = 0
                    Dim discount_key = 0


                    Dim not_discountable_department_ids_stream As New System.IO.StreamReader("department_ids_that_are_not_discountable.txt")
                    Dim not_discountable_department_ids_string As String = not_discountable_department_ids_stream.ReadToEnd
                    not_discountable_department_ids_stream.Close()

                    Dim department_ids_that_require_license_stream As New System.IO.StreamReader("department_ids_that_require_license.txt")
                    Dim department_ids_that_require_license_string As String = department_ids_that_require_license_stream.ReadToEnd
                    department_ids_that_require_license_stream.Close()



                    Dim discountable_total = 0.0
                    Dim online_discount_savings = 0.0
                    Dim online_discountable_total = 0.0
                    Session.Transaction.SetDiscountPercentage(0, 0)
                    If Session.Transaction.Entries.count > 1 Then
                        '--- BEGIN DETERMINE DISCOUNT TYPE --------------------------------------------------------------------------
                        '--- BEGIN DETERMINE DISCOUNT TYPE --------------------------------------------------------------------------
                        If CurrentCustomer.CurrentDiscount > 0 Then
                            discount_type = "permanent_discount"
                        Else
                            discount_type = "volume_discount"
                        End If
                        '--- END DETERMINE DISCOUNT TYPE --------------------------------------------------------------------------
                        '--- END DETERMINE DISCOUNT TYPE --------------------------------------------------------------------------
                        '--- BEGIN TOTAL DISCOUNT AREA---------------------------------------------------------------------------------
                        '--- and note keys of discount line items ---------------------------------------------------------------------
                        '--- BEGIN TOTAL DISCOUNT AREA---------------------------------------------------------------------------------
                        For Each TotallingForDiscountEntry In Session.Transaction.Entries
                            Dim CurrentEntryItem = TotallingForDiscountEntry.Item
                            Dim CurrentEntryItemDepartmentCode = CurrentEntryItem.DepartmentID.ToString
                            Dim CurrentEntryItemDepartmentCodeInQuotes = "'" & CurrentEntryItemDepartmentCode & "'"
                            'BEGIN Take note of the keys of the discount line items --------------------------------------------------------
                            If CurrentEntryItem.ItemLookupCode = "Discount" Then
                                discount_key = TotallingForDiscountEntry.key
                            ElseIf CurrentEntryItem.ItemLookupCode = "Online_5%_Discount" Then
                                online_discount_key = TotallingForDiscountEntry.key
                            End If
                            'END Take note of the keys of the discount line items --------------------------------------------------------
                            If CurrentCustomer.PriceLevel = 2 Then
                                If CurrentCustomer.CustomText4 <> "do" And CurrentCustomer.CustomText4 <> "DO" And CurrentCustomer.CustomText4 <> "Do" Then
                                    If department_ids_that_require_license_string.Contains(CurrentEntryItemDepartmentCodeInQuotes) Then
                                        MsgBox("This Item requires a license and this customer does not have one.", vbOKOnly Or vbInformation, "Barbersystem")
                                    End If
                                End If
                            End If
                            Dim discountable = "true"
                            If not_discountable_department_ids_string.Contains(CurrentEntryItemDepartmentCodeInQuotes) Then
                                discountable = "false"
                            End If
                            'begin totalling discounts ---------------------------------------------------------
                            If discountable = "true" And TotallingForDiscountEntry.ExtendedPrice > 0 And TotallingForDiscountEntry.Item.ItemLookupCode <> "Discount" Then
                                discountable_total = discountable_total + TotallingForDiscountEntry.ExtendedPrice
                            End If
                            If TotallingForDiscountEntry.Item.ItemLookupCode <> "Online_5%_Discount" Then
                                online_discountable_total = online_discountable_total + TotallingForDiscountEntry.ExtendedPrice
                            End If
                            'end totalling discounts ---------------------------------------------------------
                        Next
                        '--- END TOTAL DISCOUNT AREA---------------------------------------------------------------------------------
                        '--- and note keys of discount line items -------------------------------------------------------------------
                        '--- END TOTAL DISCOUNT AREA---------------------------------------------------------------------------------

                        If discount_type = "volume_discount" Then
                            '---BEGIN VOLUME DISCOUNT SCHEDULE--------------------------------------------------------------------------
                            '---BEGIN VOLUME DISCOUNT SCHEDULE--------------------------------------------------------------------------
                            'Begin Volume discount schedule ------------------------------------------
                            If discountable_total >= 0.0 And discountable_total <= 49.0 Then
                                discount_multiple = 0.0
                            ElseIf discountable_total >= 50.0 And discountable_total <= 99.0 Then
                                discount_multiple = 0.05
                            ElseIf discountable_total >= 101.0 And discountable_total <= 249.0 Then
                                discount_multiple = 0.1
                            ElseIf discountable_total >= 250.0 And discountable_total <= 499.0 Then
                                discount_multiple = 0.15
                            ElseIf discountable_total >= 500.0 And discountable_total <= 999.0 Then
                                discount_multiple = 0.2
                            ElseIf discountable_total >= 1000.0 And discountable_total <= 2499.0 Then
                                discount_multiple = 0.25
                            ElseIf discountable_total >= 2500.0 And discountable_total <= 4999.0 Then
                                discount_multiple = 0.3
                            ElseIf discountable_total >= 5000.0 And discountable_total <= 7500.0 Then
                                discount_multiple = 0.35
                            Else
                                discount_multiple = 0.0
                            End If
                            discount_savings = discountable_total * discount_multiple
                            If discount_savings > 0 Then
                                discount_savings = discount_savings * -1
                            Else
                                discount_savings = 0.0
                            End If

                            '---END VOLUME DISCOUNT SCHEDULE--------------------------------------------------------------------------
                            '---END VOLUME DISCOUNT SCHEDULE--------------------------------------------------------------------------
                        ElseIf discount_type = "permanent_discount" Then
                            Dim discount_multiple_full = CurrentCustomer.CurrentDiscount / 100
                            discount_savings = discountable_total * discount_multiple_full
                            discount_multiple = RoundIt(discount_multiple_full, 2)
                            If discount_savings > 0 Then
                                discount_savings = discount_savings * -1
                            Else
                                discount_savings = 0.0
                            End If
                        ElseIf discount_type = "none" Then
                            discount_savings = 0.0
                        End If
                        '---BEGIN ONLINE DISCOUNT SCHEDULE--------------------------------------------------------------------------
                        '---BEGIN ONLINE DISCOUNT SCHEDULE--------------------------------------------------------------------------
                        online_discount_savings = online_discountable_total * 0.05
                        '---END ONLINE DISCOUNT SCHEDULE--------------------------------------------------------------------------
                        '---END ONLINE DISCOUNT SCHEDULE--------------------------------------------------------------------------
                        For Each UpdatingDiscountEntry In Session.Transaction.Entries
                            If UpdatingDiscountEntry.Item.ItemLookupCode = "Discount" Then
                                UpdatingDiscountEntry.Comment = "Discountable Total: " & discountable_total & "  Percent:" & discount_multiple & "  Type:" & discount_type
                                UpdatingDiscountEntry.SetQuantityOnOrder(1)
                                UpdatingDiscountEntry.SetExtendedPrice(discount_savings)
                            ElseIf UpdatingDiscountEntry.Item.ItemLookupCode = "Online_5%_Discount" Then
                                UpdatingDiscountEntry.Comment = "Total: " & online_discountable_total & " Extended: " & online_discount_savings
                                UpdatingDiscountEntry.SetQuantityOnOrder(1)
                                online_discount_savings = online_discount_savings * -1
                                UpdatingDiscountEntry.SetExtendedPrice(online_discount_savings)
                            End If
                        Next
                    End If
                End If
            Else
                If Session.Transaction.Entries.count > 2 Then
                    MsgBox("Please load a Customer and verify its PriceLevel and Discount.", vbOKOnly Or vbInformation, "Barbersystem")
                End If
            End If
        End If
        Process = True
    End Function


    Function RoundIt(ByVal X As Double, ByVal DP As Integer) As Double
        RoundIt = Int((X * 10 ^ DP) + 0.5) / 10 ^ DP
    End Function


End Class

'If discount_key = 0 Then
'Session.Transaction.Entries.Add("13653", "Discount", 1, 0, False, 0)
'End If
'Else
'Session.Transaction.Entries.Add("13653", "Discount", 1, 0, False, 0)
'begin locals for debugging ----------------------------------------------------------
'Dim Transaction_Discount_Percent = Session.Transaction.DiscountPercent
'Dim CurrentEntry_Item_ItemLookupCode = CurrentEntry.Item.ItemLookupCode
'Dim CurrentEntry_Discount = CurrentEntry.Discount
'Dim CurrentEntry_DiscountPercentage = CurrentEntry.DiscountPercentage
'Dim CurrentEntry_DiscountReasonCode = CurrentEntry.DiscountReasonCode
'Dim CurrentEntry_IsDirty = CurrentEntry.IsDirty
'Dim CurrentEntry_IsPriceOverride = CurrentEntry.IsPriceOverride
'Dim CurrentEntry_PriceSource = CurrentEntry.PriceSource
'Dim CurrentEntry_Price = CurrentEntry.Price
'CurrentEntry.ResetPriceSource()
'end locals for debugging ----------------------------------------------------------