#include "ethernet.h"

static struct netif server_netif;
struct netif *echo_netif;

#if LWIP_IPV6==0
	ip_addr_t ipaddr, netmask, gw;
#endif

/* the mac address of the board. this should be unique per board */
unsigned char mac_ethernet_address[] =
{ 0x00, 0x0a, 0x35, 0x00, 0x01, 0x02 };

void print_ip(char *msg, ip_addr_t *ip)
{
	print(msg);
	xil_printf("%d.%d.%d.%d\n\r", ip4_addr1(ip), ip4_addr2(ip),
			ip4_addr3(ip), ip4_addr4(ip));
}

void print_ip_settings(ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw)
{
	print_ip("Board IP: ", ip);
	print_ip("Netmask : ", mask);
	print_ip("Gateway : ", gw);
}

int configure_ethernet(){

	echo_netif = &server_netif;

	init_platform();

	/* initialize IP addresses to be used */
	IP4_ADDR(&ipaddr,  172,  29,  28, 134);
	IP4_ADDR(&netmask, 255, 255, 255,   0);
	IP4_ADDR(&gw,      172,  29,  28,   1);

	print_app_header();

	lwip_init();

	/* receive and process packets */
	return 0;
}

int enable_ethernet(){

	/* Add network interface to the netif_list, and set it as default */
	if (!xemac_add(echo_netif, &ipaddr, &netmask,
						&gw, mac_ethernet_address,
						PLATFORM_EMAC_BASEADDR)) {
		xil_printf("Error adding N/W interface\n\r");
		return -1;
	}

	netif_set_default(echo_netif);

	/* now enable interrupts */
	platform_enable_interrupts();

	/* specify that the network if is up */
	netif_set_up(echo_netif);

	print_ip_settings(&ipaddr, &netmask, &gw);

	/* start the application (web server, rxtest, txtest, etc..) */
	start_application();

	return 0;
}

