<?xml version="1.0"?>
<fo:root   
   xmlns:fo="http://www.w3.org/1999/XSL/Format"
   xmlns:py="http://purl.org/kid/ns#">

  <fo:layout-master-set>

    <fo:simple-page-master master-name="master-pages-for-all">
      <fo:region-body   margin-right="1em" margin-left="1em" margin-top="8em" margin-bottom="4em"/>
      <fo:region-before extent="2em"/>
      <fo:region-after  extent="4em"/>
      <fo:region-start  extent="2em"/>
      <fo:region-end    extent="2em"/>
    </fo:simple-page-master>

    <fo:page-sequence-master master-name="sequence-of-pages">
      <fo:repeatable-page-master-reference master-reference="master-pages-for-all" />
    </fo:page-sequence-master>
  </fo:layout-master-set>

  <fo:page-sequence master-reference="sequence-of-pages">


    <fo:static-content 
       flow-name="xsl-region-before">          
      <fo:block>
	<!-- BEGIN HEADER -->
	<fo:table table-layout="fixed" width="100%">
	  <fo:table-body>
	    <fo:table-row>
	      <fo:table-cell>
		<fo:block><fo:external-graphic src="../images/companies/ppws2.png"/></fo:block>
	      </fo:table-cell>
	      <fo:table-cell>
		<fo:block text-align="right">
		  <fo:list-block>
		    <fo:list-item>
		      <fo:list-item-label>
			<fo:block/>
		      </fo:list-item-label>
		      <fo:list-item-body>
			<fo:block font-weight="bold">Proporta Web Solutions</fo:block>
		      </fo:list-item-body>
		    </fo:list-item>

		    <fo:list-item>
		      <fo:list-item-label>
			<fo:block/>
		      </fo:list-item-label>
		      <fo:list-item-body>
			<fo:block>Unit 3, Woodingdean Business Park</fo:block>
		      </fo:list-item-body>
		    </fo:list-item>

		    <fo:list-item>
		      <fo:list-item-label>
			<fo:block/>
		      </fo:list-item-label>
		      <fo:list-item-body>
			<fo:block>Sea View Way</fo:block>
		      </fo:list-item-body>
		    </fo:list-item>

		    <fo:list-item>
		      <fo:list-item-label>
			<fo:block/>
		      </fo:list-item-label>
		      <fo:list-item-body>
			<fo:block>Brighton</fo:block>
		      </fo:list-item-body>
		    </fo:list-item>

		    <fo:list-item>
		      <fo:list-item-label>
			<fo:block/>
		      </fo:list-item-label>
		      <fo:list-item-body>
			<fo:block>BN2 6NX</fo:block>
		      </fo:list-item-body>
		    </fo:list-item>
		  </fo:list-block>
		</fo:block>
	      </fo:table-cell>
	    </fo:table-row>
	  </fo:table-body>
	</fo:table>
	<!-- END HEADER -->
      </fo:block>
    </fo:static-content>

    <fo:static-content 
       flow-name="xsl-region-after">          
      <fo:block>
	<fo:table>
	  <fo:table-body>
	    <fo:table-row>
	      <fo:table-cell>
		<fo:block>Page 1</fo:block>
	      </fo:table-cell>
	      <fo:table-cell>
		<fo:block text-align="right">
		  
		  <fo:list-block>
		    <fo:list-item>
		      <fo:list-item-label>
			<fo:block/>
		      </fo:list-item-label>
		      <fo:list-item-body>
			<fo:block>+44 (0)845 123 2848</fo:block>
		      </fo:list-item-body>
		    </fo:list-item>

		    <fo:list-item>
		      <fo:list-item-label>
			<fo:block/>
		      </fo:list-item-label>
		      <fo:list-item-body>
			<fo:block>www.proportasolutions.com</fo:block>
		      </fo:list-item-body>
		    </fo:list-item>

		    <fo:list-item>
		      <fo:list-item-label>
			<fo:block/>
		      </fo:list-item-label>
		      <fo:list-item-body>
			<fo:block>sales@proportasolutions.com</fo:block>
		      </fo:list-item-body>
		    </fo:list-item>
		  </fo:list-block>
		</fo:block>
	      </fo:table-cell>
	    </fo:table-row>
	  </fo:table-body>
	</fo:table>
      </fo:block>

    </fo:static-content>

    <fo:flow flow-name="xsl-region-body"> 

      <fo:block text-align="right" padding="2em">${tg.format_date(invoice.date)}</fo:block>

      <fo:list-block>
	<fo:list-item>
	  <fo:list-item-label>
	    <fo:block/>
	  </fo:list-item-label>
	  <fo:list-item-body>
	    <fo:block font-weight="bold">ATTN: ${invoice.client.billing_person}</fo:block>
	  </fo:list-item-body>
	</fo:list-item>

	<fo:list-item py:for="line in address_lines">
	  <fo:list-item-label>
	    <fo:block/>
	  </fo:list-item-label>
	  <fo:list-item-body>
	    <fo:block>${line}</fo:block>
	  </fo:list-item-body>
	</fo:list-item>


      </fo:list-block>

      <fo:block padding="2em" font-size="smaller">Invoice number: ${invoice.ident}</fo:block>


      <fo:table table-layout="fixed" width="100%">
        <fo:table-column column-width="proportional-column-width(1)"/>
        <fo:table-column column-width="24em"/>
        <fo:table-column column-width="proportional-column-width(1)"/>
        <fo:table-body>
          <fo:table-row>
            <fo:table-cell column-number="2">

	      <fo:table table-layout="fixed" width="100%" border-collapse="collapse">

		<fo:table-column column-width="20em"/>
		<fo:table-column column-width="4em"/>

		<fo:table-header>
		  <fo:table-row>
		    <fo:table-cell padding="2pt" border="1pt solid black">
		      <fo:block font-weight="bold">DESCRIPTION OF GOODS/SERVICES</fo:block>
		    </fo:table-cell>
		    <fo:table-cell padding="2pt" border="1pt solid black">
		      <fo:block>Total</fo:block>
		    </fo:table-cell>
		  </fo:table-row>
		</fo:table-header>

		<fo:table-body>
		  <fo:table-row py:for="line in invoice.products">
		    <fo:table-cell padding="2pt" border="1pt solid black">
		      <fo:block>${line.quantity} x ${line.product.name}</fo:block>
		    </fo:table-cell>
		    <fo:table-cell padding="2pt" border="1pt solid black">
		      <fo:block>${line.price}</fo:block>
		    </fo:table-cell>
		  </fo:table-row>
		  <fo:table-row>
		    <fo:table-cell padding="2pt" border="1pt solid black">
		      <fo:block>Subtotal</fo:block>
		    </fo:table-cell>
		    <fo:table-cell padding="2pt" border="1pt solid black">
		      <fo:block>${invoice.total}</fo:block>
		    </fo:table-cell>
		  </fo:table-row>
		  <fo:table-row>
		    <fo:table-cell padding="2pt" border="1pt solid black">
		      <fo:block>VAT</fo:block>
		    </fo:table-cell>
		    <fo:table-cell padding="2pt" border="1pt solid black">
		      <fo:block>${invoice.vat}</fo:block>
		    </fo:table-cell>
		  </fo:table-row>
		  <fo:table-row>
		    <fo:table-cell padding="2pt" border="1pt solid black">
		      <fo:block>Grand Total</fo:block>
		    </fo:table-cell>
		    <fo:table-cell padding="2pt" border="1pt solid black">
		      <fo:block>${invoice.net_total}</fo:block>
		    </fo:table-cell>
		  </fo:table-row>
		</fo:table-body>

	      </fo:table>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>

      <fo:block padding="2em">
	<fo:leader leader-pattern="rule" leader-length="40em"/>
      </fo:block>
      <fo:block>Payment terms: ${invoice.terms}</fo:block>
    </fo:flow>


  </fo:page-sequence>

</fo:root>

