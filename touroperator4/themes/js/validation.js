/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
function isNumberKey(evt)
	{
		var charCode = (evt.which) ? evt.which : event.keyCode
		if (charCode > 31 && (charCode < 48 || charCode > 57)&&(charCode!=43))
			return false;

		return true;
	}
	
	

function validate_contactform(){
	
	var name=document.forms["contact"]["name"].value;
	  if(name==""){
		  alert("Please Enter your name.");
		  document.forms["contact"]["name"].focus();
		  return false;
	  }
	  
        var x=document.forms["contact"]["email"].value;
             var atpos=x.indexOf("@");
             var dotpos=x.lastIndexOf(".");
             if (atpos<1 || dotpos<atpos+2 || dotpos+2>=x.length)
               {
                       alert("Not a valid e-mail address");
                       document.forms["contact"]["email"].focus();
                       return false;
               }

	var telephone=document.forms["contact"]["mobile"].value;
	  if(telephone==""){
		  alert("Please Enter your Mobile Number.");
		  document.forms["contact"]["mobile"].focus();
		  return false;
	  }	
	  
	 	  
  
     var message=document.forms["contact"]["message"].value;
	  if(message==""){
		  alert("Please Enter your Message.");
		  document.forms["contact"]["message"].focus();
		  return false;
	  }	
          
         
	
}
function validate()
{
	  
var x=document.forms["form"]["userEmail"].value;
var atpos=x.indexOf("@");
var dotpos=x.lastIndexOf(".");
if (atpos<1 || dotpos<atpos+2 || dotpos+2>=x.length)
  {
  alert("The Email field must contain a valid email address.");
  return false;
  }
  
var pass=document.forms["form"]["userPassword"].value;
  if(pass==""){
  alert("The Password field is required.");
  return false;
  }	 
	  	  
}

function validate0()
{
	  
var x=document.forms["form0"]["userEmail"].value;
var atpos=x.indexOf("@");
var dotpos=x.lastIndexOf(".");
if (atpos<1 || dotpos<atpos+2 || dotpos+2>=x.length)
  {
  alert("The Email field must contain a valid email address.");
  return false;
  }
  
var pass=document.forms["form0"]["userPassword"].value;
  if(pass==""){
  alert("The Password field is required.");
  return false;
  }	 
	  	  
}

function validate1()
{

var name=document.forms["form1"]["userName"].value;
  if(name==""){
  alert("The Name field is required.");
  return false;
  }
	  
var x=document.forms["form1"]["userEmail"].value;
var atpos=x.indexOf("@");
var dotpos=x.lastIndexOf(".");
if (atpos<1 || dotpos<atpos+2 || dotpos+2>=x.length)
  {
  alert("The Email field must contain a valid email address.");
  return false;
  }	 
  
var pass=document.forms["form1"]["userPassword"].value;
  if(pass==""){
  alert("The Password field is required.");
  return false;
  }	 
  
var passcnf=document.forms["form1"]["userPasswordConf"].value;
  if(passcnf==""){
  alert("The Password Confirmation field is required.");
  return false;
  }
  
var invalid = " "; // Invalid character is a space
var minLength = 4; // Minimum length

// check for minimum length
if (document.form1.userPassword.value.length < minLength) {
alert('Your password must be at least ' + minLength + ' characters long. Try again.');
return false;
}

// check for spaces
if (document.form1.userPassword.value.indexOf(invalid) > -1) {
alert("Sorry, spaces are not allowed.");
return false;
}

if (pass != passcnf) {
alert ("The Password field does not match the Password Confirmation field.");
return false;
}
	  	  
}

function validate2()
{

var name=document.forms["form2"]["userName"].value;
  if(name==""){
  alert("The Name field is required.");
  return false;
  }
  
var profession=document.forms["form2"]["userProfession"].value;
  if(profession==""){
  alert("The Profession field is required.");
  return false;
  }  	  
}

function validate3()
{

var cpass=document.forms["form3"]["userOldPassword"].value;
  if(cpass==""){
  alert("The Current Password field is required.");
  return false;
  }
	  
var pass=document.forms["form3"]["userNewPassword"].value;
  if(pass==""){
  alert("The New password field is required.");
  return false;
  }	 
  
var passcnf=document.forms["form3"]["userNewPasswordConf"].value;
  if(passcnf==""){
  alert("The Confirm New Password field is required.");
  return false;
  }
  
var invalid = " "; // Invalid character is a space
var minLength = 4; // Minimum length

// check for minimum length
if (document.form3.userNewPassword.value.length < minLength) {
alert('Your password must be at least ' + minLength + ' characters long. Try again.');
return false;
}

// check for spaces
if (document.form3.userPassword.value.indexOf(invalid) > -1) {
alert("Sorry, spaces are not allowed.");
return false;
}

if (pass != passcnf) {
alert ("The New password field does not match the Confirm New Password field.");
return false;
}
	  	  
}

function validate4()
{
	  
var x=document.forms["form4"]["userEmail"].value;
var atpos=x.indexOf("@");
var dotpos=x.lastIndexOf(".");
if (atpos<1 || dotpos<atpos+2 || dotpos+2>=x.length)
  {
  alert("The Email field must contain a valid email address.");
  return false;
  }	 
 
	  	  
}

function validate6()
{

var npass=document.forms["form6"]["userPassword"].value;
  if(npass==""){
  alert("The New Password field is required.");
  return false;
  }
  
  var passcnf=document.forms["form6"]["userPasswordConf"].value;
  if(passcnf==""){
  alert("The Password Confirmation field is required.");
  return false;
  }
  
var invalid = " "; // Invalid character is a space
var minLength = 4; // Minimum length

// check for minimum length
if (document.form6.userPassword.value.length < minLength) {
alert('Your password must be at least ' + minLength + ' characters long. Try again.');
return false;
}

// check for spaces
if (document.form6.userPassword.value.indexOf(invalid) > -1) {
alert("Sorry, spaces are not allowed.");
return false;
}

if (npass != passcnf) {
alert ("The New password field does not match the Confirm New Password field.");
return false;
}
	  	  
}

function validate7()
{
	  
var x=document.forms["form7"]["userEmail"].value;
var atpos=x.indexOf("@");
var dotpos=x.lastIndexOf(".");
if (atpos<1 || dotpos<atpos+2 || dotpos+2>=x.length)
  {
  alert("The Email field must contain a valid email address");
  return false;
  }
  
var pass=document.forms["form7"]["userPassword"].value;
  if(pass==""){
  alert("The Password field is required.");
  return false;
  }	 
	  	  
}

function validate8()
{
	  
var x=document.forms["form8"]["userEmail"].value;
var atpos=x.indexOf("@");
var dotpos=x.lastIndexOf(".");
if (atpos<1 || dotpos<atpos+2 || dotpos+2>=x.length)
  {
  alert("The Email field must contain a valid email address");
  return false;
  }
  
var pass=document.forms["form8"]["userPassword"].value;
  if(pass==""){
  alert("The Password field is required.");
  return false;
  }	 
	  	  
}

function isNumberKey(evt)
{
    var charCode = (evt.which) ? evt.which : event.keyCode
    if (charCode > 31 && (charCode < 48 || charCode > 57)&&(charCode!=43))
        return false;

    return true;
}