/* Copyright 2016 supermicro.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * 	http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
 * implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


#include <skiboot.h>
#include <device.h>
#include <console.h>
#include <chip.h>
#include <ipmi.h>

#include "astbmc.h"

static const struct slot_table_entry p8dtu_phb0_0_slot[] = {
	{
		.etype = st_pluggable_slot,
		.location = ST_LOC_DEVFN(0,0),
		.name = "UIO Slot1",
	},
	{ .etype = st_end },
};

static const struct slot_table_entry p8dtu_phb0_2_slot[] = {
	{
		.etype = st_pluggable_slot,
		.location = ST_LOC_DEVFN(0,0),
		.name = "UIO Network",
	},
	{ .etype = st_end },
};


static const struct slot_table_entry p8dtu_plx_slots[] = {
    {
		.etype = st_pluggable_slot,
		.location = ST_LOC_DEVFN(1,0),
		.name = "PLX Slot1",
	},
	{
		.etype = st_builtin_dev,
		.location = ST_LOC_DEVFN(0x9,0),
		.name = "Onboard USB",
	},
	{
		.etype = st_builtin_dev,
		.location = ST_LOC_DEVFN(0xa,0),
		.name = "Onboard SATA1",
	},
	{
		.etype = st_builtin_dev,
		.location = ST_LOC_DEVFN(0xb,0),
		.name = "Onboard BMC",
	},
	{
		.etype = st_builtin_dev,
		.location = ST_LOC_DEVFN(0xc,0),
		.name = "Onboard SATA2",
	},
	{ .etype = st_end },
};

static const struct slot_table_entry p8dtu_plx_up[] = {
	{
		.etype = st_builtin_dev,
		.location = ST_LOC_DEVFN(0,0),
		.children = p8dtu_plx_slots,
	},
	{ .etype = st_end },
};

static const struct slot_table_entry p8dtu_phb0_1_slot[] = {
	{
		.etype = st_builtin_dev,
		.location = ST_LOC_DEVFN(0,0),
		.name = "PLX Switch",
		.children = p8dtu_plx_up,
	},
	{ .etype = st_end },
};

static const struct slot_table_entry p8dtu_phb8_0_slot[] = {
	{
		.etype = st_pluggable_slot,
		.location = ST_LOC_DEVFN(0,0),
		.name = "WIO Slot1",
	},
	{ .etype = st_end },
};

static const struct slot_table_entry p8dtu2u_phb8_1_slot[] = {
	{
		.etype = st_pluggable_slot,
		.location = ST_LOC_DEVFN(0,0),
		.name = "WIO Slot3",
	},
	{ .etype = st_end },
};

static const struct slot_table_entry p8dtu2u_phb8_2_slot[] = {
	{
		.etype = st_pluggable_slot,
		.location = ST_LOC_DEVFN(0,0),
		.name = "WIO Slot2",
	},
	{ .etype = st_end },
};

static const struct slot_table_entry p8dtu1u_phb8_1_slot[] = {
	{
		.etype = st_pluggable_slot,
		.location = ST_LOC_DEVFN(0,0),
		.name = "WIO Slot2",
	},
	{ .etype = st_end },
};

static const struct slot_table_entry p8dtu1u_phb8_2_slot[] = {
	{
		.etype = st_pluggable_slot,
		.location = ST_LOC_DEVFN(0,0),
		.name = "WIO Slot3",
	},
	{ .etype = st_end },
};

static const struct slot_table_entry p8dtu2u_phb_table[] = {
	{
		.etype = st_phb,
		.location = ST_LOC_PHB(0,0),
		.children = p8dtu_phb0_0_slot,
	},
	{
		.etype = st_phb,
		.location = ST_LOC_PHB(0,1),
		.children = p8dtu_phb0_1_slot,
	},
	{
		.etype = st_phb,
		.location = ST_LOC_PHB(0,2),
		.children = p8dtu_phb0_2_slot,
	},
	{
		.etype = st_phb,
		.location = ST_LOC_PHB(8,0),
		.children = p8dtu_phb8_0_slot,
	},
	{
		.etype = st_phb,
		.location = ST_LOC_PHB(8,1),
		.children = p8dtu2u_phb8_1_slot,
	},
	{
		.etype = st_phb,
		.location = ST_LOC_PHB(8,2),
		.children = p8dtu2u_phb8_2_slot,
	},
	{ .etype = st_end },
};

static const struct slot_table_entry p8dtu1u_phb_table[] = {
	{
		.etype = st_phb,
		.location = ST_LOC_PHB(0,0),
		.children = p8dtu_phb0_0_slot,
	},
	{
		.etype = st_phb,
		.location = ST_LOC_PHB(0,1),
		.children = p8dtu_phb0_1_slot,
	},
	{
		.etype = st_phb,
		.location = ST_LOC_PHB(0,2),
		.children = p8dtu_phb0_2_slot,
	},
	{
		.etype = st_phb,
		.location = ST_LOC_PHB(8,0),
		.children = p8dtu_phb8_0_slot,
	},
	{
		.etype = st_phb,
		.location = ST_LOC_PHB(8,1),
		.children = p8dtu1u_phb8_1_slot,
	},
	{
		.etype = st_phb,
		.location = ST_LOC_PHB(8,2),
		.children = p8dtu1u_phb8_2_slot,
	},
	{ .etype = st_end },
};

static bool p8dtu1u_probe(void)
{
	if (!dt_node_is_compatible(dt_root, "supermicro,p8dtu1u"))
		return false;

	/* Lot of common early inits here */
	astbmc_early_init();
	slot_table_init(p8dtu1u_phb_table);

	return true;
}

static bool p8dtu2u_probe(void)
{
	if (!dt_node_is_compatible(dt_root, "supermicro,p8dtu2u"))
		return false;

	/* Lot of common early inits here */
	astbmc_early_init();
	slot_table_init(p8dtu2u_phb_table);

	return true;
}

static const struct bmc_platform astbmc_smc = {
	.name = "SMC",
	.ipmi_oem_partial_add_esel   = IPMI_CODE(0x3a, 0xf0),
	.ipmi_oem_pnor_access_status = IPMI_CODE(0x3a, 0x07),
};


DECLARE_PLATFORM(p8dtu1u) = {
	.name			= "p8dtu1u",
	.probe			= p8dtu1u_probe,
	.bmc			= &astbmc_smc,
	.init			= astbmc_init,
	.pci_get_slot_info	= slot_table_get_slot_info,
	.pci_probe_complete	= check_all_slot_table,
	.external_irq		= astbmc_ext_irq_serirq_cpld,
	.cec_power_down         = astbmc_ipmi_power_down,
	.cec_reboot             = astbmc_ipmi_reboot,
	.elog_commit		= ipmi_elog_commit,
	.start_preload_resource	= flash_start_preload_resource,
	.resource_loaded	= flash_resource_loaded,
	.exit			= ipmi_wdt_final_reset,
	.terminate		= ipmi_terminate,
};

DECLARE_PLATFORM(p8dtu2u) = {
	.name			= "p8dtu2u",
	.probe			= p8dtu2u_probe,
	.bmc			= &astbmc_smc,
	.init			= astbmc_init,
	.pci_get_slot_info	= slot_table_get_slot_info,
	.pci_probe_complete	= check_all_slot_table,
	.external_irq		= astbmc_ext_irq_serirq_cpld,
	.cec_power_down         = astbmc_ipmi_power_down,
	.cec_reboot             = astbmc_ipmi_reboot,
	.elog_commit		= ipmi_elog_commit,
	.start_preload_resource	= flash_start_preload_resource,
	.resource_loaded	= flash_resource_loaded,
	.exit			= ipmi_wdt_final_reset,
	.terminate		= ipmi_terminate,
};

