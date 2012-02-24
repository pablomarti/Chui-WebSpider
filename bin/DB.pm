package DB;

use strict;
use warnings;
use DBI;
use Config::IniFiles;


sub new{
	my ($class) = shift;
   	my $self = {};
	bless $self, $class;
	$self->{_connected} = 0;
	$self->{_config} = Config::IniFiles->new( -file => "bin/config.ini" );
	connectAsCore($self);
	
	return $self;
}


sub connectDataBase{
	my $self = shift;
	disconnectDataBase($self);
	$self->{_connected} = 1;
	$self->{_db} = DBI->connect("DBI:mysql:" . $self->{_database}, $self->{_usr}, $self->{_pss}) or $self->{_connected} = 0;
	if($self->{_connected}){
		$self->{_db}->do("USE " . $self->{_database} . ";") or die "Error in DataBase Manager: " . $self->{_db}->errstr . "\n";
	}
}


sub connectAsAdmin{
	my $self = shift;
	$self->{_usr} = $self->{_config}->val('DBAdmin','user');
	$self->{_pss} = $self->{_config}->val('DBAdmin','pass');
	$self->{_database} = $self->{_config}->val('DBAdmin','db');
	connectDataBase($self);
}


sub connectAsCore{
	my $self = shift;
	$self->{_usr} = $self->{_config}->val('DBCore','user');
	$self->{_pss} = $self->{_config}->val('DBCore','pass');
	$self->{_database} = $self->{_config}->val('DBCore','db');	
	connectDataBase($self);
}


sub query{
	my ($self, $qry) = @_;
	my $query = $self->{_db}->prepare($qry) or die "Error in DataBase Manager: " . $self->{_db}->errstr . "\n";
	$query->execute() or die "Cause: " . $query->errstr . "\n";
	return $query;
}


sub prepare{
	my ($self, $qry) = @_;
	my $query = $self->{_db}->prepare($qry) or die "Error in DataBase Manager: " . $self->{_db}->errstr . "\n";
	return $query;
}


sub do{
	my ($self, $qry) = @_;
	my $sTry = 0;
	$self->{_db}->do($qry) or $sTry++;
	if($sTry){
		$self->{_db}->do($qry) or $sTry++;
		if($sTry){
			$self->{_db}->do($qry) or die "Error in DataBase Manager: " . $self->{_db}->errstr . ": $qry\n";
		}
	}
}


sub disconnectDataBase{
	my $self = shift;
	if($self->{_connected}){
		$self->{_db}->disconnect();
		$self->{_connected} = 0;
	}
}


sub DESTROY{
	my $self = shift;
	disconnectDataBase($self);	
	$self = undef;
}

 1;

__END__

Database Manager
