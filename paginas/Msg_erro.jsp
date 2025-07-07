<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<style>
  body {
    background-image: url(./fundoLogin.jpg);
    background-position: top center;
    background-size: cover;
}

#erro-box {
    background-color: #F78181;
    width: 380px;
    height: 200px;
    margin: 140px auto 0px;
    overflow: hidden;
    box-shadow: 0px 0px 5px #6F6666;
}
  
#erro-cabecalho {
    background-color: red;
    height: 50px;
    border-bottom: 2px solid #BDBDBD;
    text-align: center;
    font: bold 20px/50px sans-serif;
    color: white;
}
  
.input-div {
    margin: 20px;
    padding: 5px;
    font: bold 15px sans-serif;
    color: black;
}
 
.input-div input {
    width: 325px;
    height: 35px;
    padding-left: 7px;
    font: normal 13px sans-serif;
    color: #0B6121;
}
  
#acoes {
    width: 330px;
    margin: 25px;
}
  
input[type=submit] {
    float: right;
    background-color: red;
    padding: 10px 50px;
    margin-top: -15px;
    font: bold 13px sans-serif;
    color: white;
    box-shadow: 2px 2px 5px #6F6666;
    cursor: pointer;
    border: 0px;
}
  
input[type=submit]:hover {
    box-shadow: 1px 1px 5px #6F6666;
}
  
</style>
</head>
<body>

  <div id='erro-box'>
      <div id='erro-cabecalho'>Lamentamos... Algo não correu bem.</div>

  </div>

  <script>
      setTimeout(function() {window.location.href = "logout.jsp";}, 3000);
      // 3000ms = 3
  </script>
</body> 
</html>
