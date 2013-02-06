package CDO_Q_Calc;

sub new
{
    my $self = {};
    bless $self;
    return $self;
}

sub Qhat_OpenLog {
 my ($self, $CurrentDate, $DIR) = @_;
 open(QHAT, ">$DIR/qhat.csv");
 #print QHAT "Cell,san,lp_var,cell_n,cell_a,cpsssd_n,cpsssd_a,cpsssd_q,cpsssd_cells,cpssd_n,cpssd_a,cpssd_q,cpssd_cells,cps_n,cps_a,cps_q,cps_cells,sssd_n,sssd_a,sssd_q,sssd_cells,szd_n,szd_a,szd_q,szd_cells,";
 #print QHAT "ssd_n,ssd_a,ssd_q,ssd_cells,sd_n,sd_a,sd_q,sd_cells,zd_n,zd_a,zd_q,zd_cells,R_cell,qhat_cell,R_cpsssd,qhat_cpsssd,R_cpssd,qhat_cpssd,R_cps,qhat_cps,";
 #print QHAT "R_sssd,qhat_sssd,R_szd,qhat_szd,R_ssd,qhat_ssd,R_sd,qhat_sd,R_zd,qhat_zd,beta,status\n";
 print QHAT "cell,san,lp_var,cell_n,cell_a,qhat,imp_factor,md_factor,avail_n,status\n";
}

sub Qhat_CloseLog {
 close QHAT;
}

sub getOptimizationData
{
    my($self, $dow, $hour, $log) = @_;
    use Logger;
    use DateFunctions;
    my $logger = new Logger;
    my $DateFunctions = new DateFunctions;

    use qHatAggregations;
    my $qHatAgg = qHatAggregations->new();

    my($cellKNA) = $qHatAgg->cell($dow, $hour, $log);
        $logger->write($log, "           -> ".$DateFunctions->currentTime().": Cell Level Data Loaded\n");

    my($cpsSiteSegment, $cpsSegment, $cps) = $qHatAgg->cps($dow, $hour);
        $logger->write($log, "           -> ".$DateFunctions->currentTime().": CPS Level Loaded\n");

    my($siteSizeSegment, $siteSegment, $siteSize) = $qHatAgg->site($dow, $hour);
        $logger->write($log, "           -> ".$DateFunctions->currentTime().": Site Level Data Loaded\n");

    my($segment) = $qHatAgg->segment($dow, $hour);
        $logger->write($log, "           -> ".$DateFunctions->currentTime().": Segment Level Data Loaded\n");

    my($size) = $qHatAgg->size($dow, $hour);
        $logger->write($log, "           -> ".$DateFunctions->currentTime().": Size Level Data Loaded\n");

    my($availImpressions) = $qHatAgg->available();
    my($availImpressionsAvg) = $qHatAgg->availableAvg();
        $logger->write($log, "           -> ".$DateFunctions->currentTime().": Avail. Impressions Loaded\n");

    my $optData = {};
    $$optData{'cellKNA'} = $cellKNA;
    $$optData{'cpsSiteSegment'} = $cpsSiteSegment;
    $$optData{'cpsSegment'} = $cpsSegment;
    $$optData{'cps'} = $cps;
    $$optData{'siteSizeSegment'} = $siteSizeSegment;
    $$optData{'siteSegment'} = $siteSegment;
    $$optData{'siteSize'} = $siteSize;
    $$optData{'segment'} = $segment;
    $$optData{'size'} = $size;
    $$optData{'availImpressions'} = $availImpressions;
    $$optData{'availImpressionsAvg'} = $availImpressionsAvg;
    

    return($optData);
}

sub Qhat {
	my ($self, $Cell, $optData, $cell_ind, $imp_factor, $md_factor) = @_;

        ### General Variables
	my $san = $$Cell{$cell_ind}{'san'};
        
        ### Indeces
        # Site
        my $sss_ind = $$Cell{$cell_ind}{'siteid'}."_".$$Cell{$cell_ind}{'size'}."_".$$Cell{$cell_ind}{'segmentid'};
        my $ss_ind = $$Cell{$cell_ind}{'siteid'}."_".$$Cell{$cell_ind}{'segmentid'};
        my $sz_ind = $$Cell{$cell_ind}{'siteid'}."_".$$Cell{$cell_ind}{'size'};
        
        # Segment
        my $s_ind = $$Cell{$cell_ind}{'segmentid'};

        # CPS
        my $cpsss_ind = $$Cell{$cell_ind}{'san'}."_".$$Cell{$cell_ind}{'size'}."_".$$Cell{$cell_ind}{'adgroup'}."_".$$Cell{$cell_ind}{'siteid'}."_".$$Cell{$cell_ind}{'segmentid'};
        my $cpss_ind = $$Cell{$cell_ind}{'san'}."_".$$Cell{$cell_ind}{'size'}."_".$$Cell{$cell_ind}{'adgroup'}."_".$$Cell{$cell_ind}{'siteid'};
        my $cps_ind = $$Cell{$cell_ind}{'san'}."_".$$Cell{$cell_ind}{'size'}."_".$$Cell{$cell_ind}{'adgroup'};

        # Size
        my $z_ind = $$Cell{$cell_ind}{'size'};

        # Cell
        my $lp_ind = $$Cell{$cell_ind}{'san'}."_".$$Cell{$cell_ind}{'adid'}."_".$$Cell{$cell_ind}{'siteid'}."_".$$Cell{$cell_ind}{'segmentid'}."_".$$Cell{$cell_ind}{'size'};
        
        # Price Volume
        my $pv_ind = $$Cell{$cell_ind}{'san'}."_".$$Cell{$cell_ind}{'siteid'}."_".$$Cell{$cell_ind}{'segmentid'}."_".$$Cell{$cell_ind}{'size'};
        my $pv_avg_ind = $$Cell{$cell_ind}{'siteid'}."_".$$Cell{$cell_ind}{'segmentid'}."_".$$Cell{$cell_ind}{'size'};
        
        ### Imp,Action,Cells
        # Cells
    	my $sssd_cells = &noNull($$optData{'siteSizeSegment'}{$sss_ind}{'cells'},0);
    	my $szd_cells = &noNull($$optData{'siteSize'}{$sz_ind}{'cells'},0);
    	my $ssd_cells = &noNull($$optData{'siteSegment'}{$ss_ind}{'cells'},0);
    	my $sd_cells = &noNull($$optData{'segment'}{$s_ind}{'cells'},0);
    	my $zd_cells =  &noNull($$optData{'size'}{$z_ind}{'cells'},0);
    	my $cps_cells =  &noNull($$optData{'cps'}{$cps_ind}{'cells'},0);
    	my $cpssd_cells = &noNull($$optData{'cpsSegment'}{$cpss_ind}{'cells'},0);
    	my $cpsssd_cells = &noNull($$optData{'cpsSiteSegment'}{$cpsss_ind}{'cells'},0);

        # Impressions
    	my $sssd_n = &noNull($$optData{'siteSizeSegment'}{$sss_ind}{'n'},0);
    	my $szd_n = &noNull($$optData{'siteSize'}{$sz_ind}{'n'},0);
    	my $ssd_n = &noNull($$optData{'siteSegment'}{$ss_ind}{'n'},0);
    	my $sd_n = &noNull($$optData{'segment'}{$s_ind}{'n'},0);
    	my $zd_n = &noNull($$optData{'size'}{$z_ind}{'n'},0);
    	my $cps_n = &noNull($$optData{'cps'}{$cps_ind}{'n'},0);
    	my $cpssd_n = &noNull($$optData{'cpsSegment'}{$cpss_ind}{'n'},0);
    	my $cpsssd_n = &noNull($$optData{'cpsSiteSegment'}{$cpsss_ind}{'n'},0);

        # Actions
    	my $sssd_a = &noNull($$optData{'siteSizeSegment'}{$sss_ind}{'a'},0);
    	my $szd_a = &noNull($$optData{'siteSize'}{$sz_ind}{'a'},0);
    	my $ssd_a = &noNull($$optData{'siteSegment'}{$ss_ind}{'a'},0);
    	my $sd_a = &noNull($$optData{'segment'}{$s_ind}{'a'},0);
    	my $zd_a = &noNull($$optData{'size'}{$z_ind}{'a'},0);
    	my $cps_a = &noNull($$optData{'cps'}{$cps_ind}{'a'},0);
    	my $cpssd_a = &noNull($$optData{'cpsSegment'}{$cpss_ind}{'a'},0);
    	my $cpsssd_a = &noNull($$optData{'cpsSiteSegment'}{$cpsss_ind}{'a'},0);

        # Cell Level (Imp, Action)
    	my $cell_n = &noNull($$optData{'cellKNA'}{$lp_ind}{'n'},0);
    	my $cell_a = &noNull($$optData{'cellKNA'}{$lp_ind}{'a'},0);

        # Price/Volume
    	my $avail_n = &noNull($$optData{'availImpressions'}{$pv_ind}{'capped_volume'},0);
        my $avail_avg_n = &noNull($$optData{'availImpressionsAvg'}{$pv_avg_ind}{'capped_volume'},0);

    
    ### Base CVR
    my $sssd_q = &noDivByZero($sssd_n, $sssd_a, 0);
    my $szd_q = &noDivByZero($szd_n, $szd_a, 0);
    my $ssd_q = &noDivByZero($ssd_n, $ssd_a, 0);
    my $sd_q = &noDivByZero($sd_n, $sd_a, 0);
    my $zd_q = &noDivByZero($zd_n, $zd_a, 0);
    my $cps_q = &noDivByZero($cps_n, $cps_a, 0);
    my $cpssd_q = &noDivByZero($cpssd_n, $cpssd_a, 0);
    my $cpsssd_q = &noDivByZero($cpsssd_n, $cpsssd_a, 0);

    my $beta = 1000000; ### Arbitrary scaling
    my $status;
    my $R_zd;
    my $qhat_zd;
    my $R_sd;
    my $qhat_sd;
    my $R_ssd;
    my $qhat_ssd;
    my $R_szd;
    my $qhat_szd;
    my $R_sssd;
    my $qhat_sssd;
    my $R_cps;
    my $qhat_cps;
    my $R_cpssd;
    my $qhat_cpssd;
    my $R_cpsssd;
    my $qhat_cpsssd;

        #print "$cell_ind,$san,$lp_ind,$cell_n,$cell_a,$cpsssd_n,$cpsssd_a,$cpsssd_q,$cpsssd_cells,$cpssd_n,$cpssd_a,$cpssd_q,$cpssd_cells,$cps_n,$cps_a,$cps_q,$cps_cells,$sssd_n,$sssd_a,$sssd_q,$sssd_cells,$szd_n,$szd_a,$szd_q,$szd_cells,$ssd_n,$ssd_a,";
        #print "$ssd_q,$ssd_cells,$sd_n,$sd_a,$sd_q,$sd_cells,$zd_n,$zd_a,$zd_q\n";
#        print "$cell_ind, $lp_ind, $cell_n, $avail_n\n";

###
    if($zd_cells>0 && $zd_n>0)
    	{
    		$R_zd = (($zd_n + 2)**2 * ($zd_n + 3))/(($zd_a + 1) * ($zd_n - $zd_a + 1)) * ($beta/$zd_cells);
    		$qhat_zd = $zd_q;
    	}
    else
    	{
    		$R_zd = 1;
    		$qhat_zd = 0.000000000001;
    	}
#
###
	if($sd_cells>0 && $sd_n>0)
		{
    		$R_sd = (($sd_n + 2)**2 * ($sd_n + 3))/(($sd_a + 1) * ($sd_n - $sd_a + 1)) * ($beta/$sd_cells);
    		$qhat_sd = (($R_sd*($sd_a/$sd_n)) + ($R_zd * $qhat_zd))/($R_sd + $R_zd);
		}
	else 
		{
			$R_sd = 1;
			$qhat_sd = 0 + ($R_zd * $qhat_zd)/($R_sd + $R_zd);
		}
#
###	
	if($ssd_cells>0 && $ssd_n>0)
		{
    		$R_ssd = (($ssd_n + 2)**2 * ($ssd_n + 3))/(($ssd_a + 1) * ($ssd_n - $ssd_a + 1)) * ($beta/$ssd_cells);
    		$qhat_ssd = (($R_ssd*($ssd_a/$ssd_n)) + ($R_sd * $qhat_sd))/($R_ssd + $R_sd);
		}
	else 
		{
			$R_ssd = 1;
			$qhat_ssd = 0 + ($R_sd * $qhat_sd)/($R_ssd + $R_sd);
		}
#
###
	if($szd_cells>0 && $szd_n>0)
		{
			$R_szd = (($szd_n + 2)**2 * ($szd_n + 3))/(($szd_a + 1) * ($szd_n - $szd_a + 1)) * ($beta/$szd_cells);
    		$qhat_szd = (($R_szd*($szd_a/$szd_n)) + ($R_ssd * $qhat_ssd))/($R_szd + $R_ssd);
		}
	else
		{
			$R_szd = 1;
			$qhat_szd = 0 + ($R_ssd * $qhat_ssd)/($R_szd + $R_ssd);	
		}
#
###
	if($sssd_cells>0 && $sssd_n>0)
		{
		    $R_sssd = (($sssd_n + 2)**2 * ($sssd_n + 3))/(($sssd_a + 1) * ($sssd_n - $sssd_a + 1)) * ($beta/$sssd_cells);
		    $qhat_sssd = (($R_sssd*($sssd_a/$sssd_n)) + ($R_szd * $qhat_szd))/($R_sssd + $R_szd);
	
		}
	else
		{
			$R_sssd = 1;
			$qhat_sssd = 0 + ($R_szd * $qhat_szd)/($R_sssd + $R_szd);
		}
#
###
	if($cps_cells>0 && $cps_n>0)
		{
			$R_cps = (($cps_n + 2)**2 * ($cps_n + 3))/(($cps_a + 1) * ($cps_n - $cps_a + 1)) * ($beta/$cps_cells);
    		$qhat_cps = (($R_cps*($cps_a/$cps_n)) + ($R_sssd * $qhat_sssd))/($R_cps + $R_sssd);			
		}
	else
		{
			$R_cps = 1;
			$qhat_cps = 0 + ($R_sssd * $qhat_sssd)/($R_cps + $R_sssd);
		}
#
###
	if($cpssd_cells>0 && $cpssd_n>0)
		{
    		$R_cpssd = (($cpssd_n + 2)**2 * ($cpssd_n + 3))/(($cpssd_a + 1) * ($cpssd_n - $cpssd_a + 1)) * ($beta/$cpssd_cells);
    		$qhat_cpssd = (($R_cpssd*($cpssd_a/$cpssd_n)) + ($R_cps * $qhat_cps))/($R_cpssd + $R_cps);
		}
	else
		{
			$R_cpssd = 1;
			$qhat_cpssd = 0 + ($R_cps * $qhat_cps)/($R_cpssd + $R_cps);
		}
#
###
	if($cpsssd_cells>0 && $cpsssd_n>0)
		{
    		$R_cpsssd = (($cpsssd_n + 2)**2 * ($cpsssd_n + 3))/(($cpsssd_a + 1) * ($cpsssd_n - $cpsssd_a + 1)) * ($beta/$cpsssd_cells);
    		$qhat_cpsssd = (($R_cpsssd*($cpsssd_a/$cpsssd_n)) + ($R_cpssd * $qhat_cpssd))/($R_cpsssd + $R_cpssd);	
		}
	else 
		{
			$R_cpsssd = 1;
			$qhat_cpsssd = 0 + ($R_cpssd * $qhat_cpssd)/($R_cpsssd + $R_cpssd);
		}
#
###
        #print "$lp_ind: n=$cell_n, a(x)=$cell_a, ";
        if ($cell_n < $cell_a) { $cell_a = $cell_n; }
        #print "a(x+1)=$cell_a, f(a,n)=($cell_a + 1) * ($cell_n - $cell_a + 1)\n";
	$R_cell = (($cell_n + 2)**2 * ($cell_n + 3))/(($cell_a + 1) * ($cell_n - $cell_a + 1)) * ($beta);
		
	if($cell_n>0)
		{
    		$qhat = (($R_cell*($cell_a/$cell_n)) + ($R_sssd * $qhat_sssd))/($R_cell + $R_sssd);	
		}
	else
		{
			$qhat = 0 + ($R_sssd * $qhat_sssd)/($R_cell + $R_sssd);
		}
#

####
            if ($cell_a > 0) {
               $status = "Cell";
            }
            elsif ($cpsssd_q > 0){
            	$status = "CPS/Site/Segment"
            }
            elsif ($cpssd_q > 0){
            	$status = "CPS/Segment"
            }
            elsif ($cps_q > 0){
            	$status = "CPS"
            }
            elsif ($sssd_q > 0){
               $status = "Site/Size/Segment";
            }
            elsif ($szd_q > 0) {
               $status = "Site/Size";
            }
            elsif ($ssd_q > 0) {
               $status = "Site/Segment";
            }
            elsif ($sd_q > 0) {
               $status = "Segment";
            }
            else {
               $status = "Size";
            }
####

 #print QHAT "$cell_ind,$san,$lp_ind,$cell_n,$cell_a,$cpsssd_n,$cpsssd_a,$cpsssd_q,$cpsssd_cells,$cpssd_n,$cpssd_a,$cpssd_q,$cpssd_cells,$cps_n,$cps_a,$cps_q,$cps_cells,$sssd_n,$sssd_a,$sssd_q,$sssd_cells,$szd_n,$szd_a,$szd_q,$szd_cells,$ssd_n,$ssd_a,";
 #print QHAT "$ssd_q,$ssd_cells,$sd_n,$sd_a,$sd_q,$sd_cells,$zd_n,$zd_a,$zd_q,$zd_cells,$R_cell,$qhat,$R_cpsssd,$qhat_cpsssd,$R_cpssd,$qhat_cpssd,$R_cps,$qhat_cps,";
 #print QHAT "$R_sssd,$qhat_sssd,$R_szd,$qhat_szd,$R_ssd,$qhat_ssd,$R_sd,$qhat_sd,$R_zd,$qhat_zd,$beta,$status\n";
 print QHAT "$cell_ind,$san,$pv_ind,$cell_n,$cell_a,$qhat,$imp_factor,$md_factor,$avail_n,$status\n";

    return ($qhat, $status);
}

sub avg_CPI_OpenLog {
  my ($self, $CurrentDate, $DIR) = @_;
  open(COST, ">$DIR/cost.txt");
}

sub avg_CPI_CloseLog {
  close COST;
}

sub avg_CPI {
my ($self, $max_alpha, $pv_hash, $ci, $cell) = @_;
       my $avg_cpi;
       my $avail;
       my $avail_capped;

       my $n = 0;
       my $price = 0;
            foreach $a (sort keys %{$$pv_hash{$ci}}) {
                    $n++;
                    $price = $price + $$pv_hash{$ci}{$a}{'bid'};
                    if ($a == $max_alpha) { last; }
                    
                    $avail = $$pv_hash{$ci}{$a}{'avail_imps'} * $max_alpha;
                    $avail_capped = $$pv_hash{$ci}{$a}{'avail_capped_imps'} * $max_alpha;
            }

                if ($n == 0) {
                     $avg_cpi = 0;
                }
                else {
                     $avg_cpi = ($price/$n)/1000;
                }

            #print COST "$cell: max alpha = $max_alpha, total cost = $price, num bids = $n, avg_CPI = $avg_cpi, avail imps = $avail, avail imps (capped) = $avail_capped\n";

    return $avg_cpi;

}

sub isGreater {
  
  my ($self, $a, $b) = @_;
  
  if ($a > $b) { return $a; }
  else { return $b; }

}

sub noDivByZero {
	my ($denom, $num, $sub) = @_;
	my $out;
	
	if ($denom > 0)
		{
			$out = $num/$denom;		
		}
	else
		{
			$out = $sub;
		}
	
	return $out;
}

sub noNull {
	my ($input, $output) = @_;

	if ($input > 0)
		{
			return $input;	
		}
	else
		{
			return $output;
		}
}

1;
