			var hidden = false;
			
			window.onload = 
			function ()
			{
				if(document.getElementById){
					//alert("NS above 4");
					var indexOne = document.getElementById("firstPassCodeDigit").selectedIndex;
					var indexTwo = document.getElementById("secondPassCodeDigit").selectedIndex;
					setValues(document.getElementById("firstPassCodeDigit"));
					setValues(document.getElementById("secondPassCodeDigit"));
					if( indexOne >=1)
					{
						document.getElementById("firstPassCodeDigit").options[indexOne].text="*";
					}
					if( indexTwo >=1)
					{
						document.getElementById("secondPassCodeDigit").options[indexTwo].text="*";
					}
				} else if(document.all) {
					//alert("IE ");
					var indexOne = document.all["firstPassCodeDigit"].selectedIndex;
					var indexTwo = document.all["secondPassCodeDigit"].selectedIndex;
					setValues(document.all["firstPassCodeDigit"]);
					setValues(document.all["secondPassCodeDigit"]);
					if( indexOne >=1)
					{
						document.all["firstPassCodeDigit"].options[indexOne].text="*";
					}
					if( indexTwo >=1)
					{
						document.all["secondPassCodeDigit"].options[indexTwo].text="*";
					}
				
				} else if( document.layers){
					//alert("NS  4");
					var indexOne = document.forms[0].firstPassCodeDigit.selectedIndex;
					var indexTwo = document.forms[0].secondPassCodeDigit.selectedIndex;
					setValues(document.forms[0].firstPassCodeDigit);
					setValues(document.forms[0].secondPassCodeDigit);
					if( indexOne >=1)
					{
						document.forms[0].secondPassCodeDigit.options[indexOne].text="*";
					}
					if( indexTwo >=1)
					{
						document.forms[0].secondPassCodeDigit.options[indexTwo].text="*";
					}
					
				}
				
			}
			
			function setValues(objList)
			{
				objList.options[ 0].text = "";
				objList.options[ 1].text = " 0";
				objList.options[ 2].text = " 1";
				objList.options[ 3].text = " 2";
				objList.options[ 4].text = " 3";
				objList.options[ 5].text = " 4";
				objList.options[ 6].text = " 5";
				objList.options[ 7].text = " 6";
				objList.options[ 8].text = " 7";
				objList.options[ 9].text = " 8";
				objList.options[10].text = " 9";
				
			}
			function hideSelection(objList)
			{
			  

			  if (!hidden)
			  {
				objList.options[ 0].text = "";
				objList.options[ 1].text = "*";
				objList.options[ 2].text = "*";
				objList.options[ 3].text = "*";
				objList.options[ 4].text = "*";
				objList.options[ 5].text = "*";
				objList.options[ 6].text = "*";
				objList.options[ 7].text = "*";
				objList.options[ 8].text = "*";
				objList.options[ 9].text = "*";
				objList.options[10].text = "*";
				hidden = true;
			  }
				doYN="Y";
				doYN2="Y";	
			}


			function showSelection(objList)
			{

			  g_bTabEnabled=true;
			
	          
			  if (hidden)
			  {
			  	setValues(objList);
				hidden = false;
				objList.selectedIndex=0;
			  }
			   

			}
			
			var countOne=1;

			var doYN = "Y";

			function appearMaskedOne(objList,event)
			{
				if(!event) var event =window.event;
				var whichEvent = event.type;
							
				if(whichEvent == "keydown")
				{
					doYN = "N";
					countOne=1;
				}
				
				else if (doYN == "Y")
				{
					
						g_bTabEnabled=true;
						if( countOne != 1)
						{
							setValues(objList);
							countOne--;
						}
						countOne++;
						objList.options[objList.selectedIndex].text="*";
						
						if(document.getElementById){
						    document.getElementById("secondPassCodeDigit").focus();
						} else if(document.all){
						    document.all["secondPassCodeDigit"].focus();
						} else if(document.layers){
						    document.forms[0].secondPassCodeDigit.focus();
						}
						
				}
				else
					{
						
						doYN = "Y";
						
					}

								
			}
						
			var countTwo =1;
			var doYN2 = "Y";
			function appearMaskedTwo(objList,event)
			{
				if(!event) var event =window.event;
				var whichEvent = event.type;
										
				if(whichEvent == "keydown")
				{
					doYN2 = "N";
				}
				
				else if (doYN2 == "Y")
				{

					g_bTabEnabled=true;

					if( countTwo != 1)
					{
						setValues(objList);
						countTwo--;
					}
					countTwo++;

					objList.options[objList.selectedIndex].text="*";
					if(document.getElementById){
					    document.getElementsByTagName("input")[1].focus();
					} else if(document.all){
					    document.all["ok"].focus();
					} else if(document.layers){
					    document.forms[0].ok.focus();
					}
					
					
				}
				else
					{
						doYN2 = "Y";
					}

				

			}

			function displayList(objList)
			{
					g_bTabEnabled=true;
					setValues(objList);

			}

