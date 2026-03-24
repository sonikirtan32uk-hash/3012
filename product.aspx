<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="product.aspx.cs" Inherits="product" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
    .p2
    {
        text-align:right;
        }
        .p4
        {
            margin-left:200px;
            width:70%;
            }
    .panel
    {
        position:absolute;
        }
.p1
{
    
    position:relative;
        top: 242px;
        left: 10px;
        width: 1596px;
        height: 353px;
    }
    .btn
    {
        
        }
    .panel1
    {}
    #Text1
    {
        width: 747px;
        height: 134px;
        margin-left: 4px;
        margin-top: 0px;
        margin-bottom: 91px;
    }
    #Text2
    {
        width: 747px;
        height: 134px;
        margin-left: 4px;
        margin-top: 0px;
        margin-bottom: 91px;
    }
    #Text3
    {
        width: 747px;
        height: 134px;
        margin-left: 4px;
        margin-top: 0px;
        margin-bottom: 91px;
    }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:Panel ID="Panel4" runat="server" CssClass="p4">
    <asp:Panel ID="Panel1" runat="server" Height="300px"  >
        <asp:Image ID="Image5" runat="server" Width="209px" Height="208px" 
            CssClass="img1" 
            style="margin-left: 61px; margin-right: 61px; margin-top: 45px; margin-bottom: 44px;" />
        <span style="text-align:center; padding:80px;position:absolute; top: 76px; left: 650px; height: 25px; width: 279px; margin-bottom: 3px; margin-top: 41px;">Bird House
        <br />
        jksdfhkjsaf<br /> sajdfgfsfhj<br /> asdkffgb<br /> </span> <br /> 
        </asp:Panel>
    
<asp:Panel ID="Panel2" runat="server" CssClass="p2">
    &nbsp;<asp:Image ID="Image6" runat="server" Width="209px" Height="208px" 
            CssClass="img1" style="margin-left: 61px; margin-right: 61px; margin-top: 45px; margin-bottom: 44px;" />
           <span style="text-align:center; padding:50px; position:absolute; top: 424px; left: 484px; width: 291px; height: 57px;"> kasdfhkj</span>
</asp:Panel>
<asp:Panel ID="Panel3" runat="server" >
    <asp:Image ID="Image1" runat="server" Width="209px" Height="208px" 
            CssClass="img1" 
        style="margin-left: 61px; margin-right: 61px; margin-top: 45px; margin-bottom: 44px;" />
    &nbsp;</asp:Panel>
    <span style="text-align:center; margin:50px; padding:50px; position:absolute;"> asdfdfsgs</span>
</asp:Panel>
</asp:Content>

