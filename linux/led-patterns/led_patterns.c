#include <linux/module.h> //basic kernel module definitions
#include <linux/platform_device.h> //platform driver/ device definitions
#include <linux/mod_devicetable.h> //of_device_id,MODULE_DEVICE_TABLE
#include <linux/io.h> //iowrite32/ioread32 functions

#define BASE_PERIOD_OFFSET 4
#define HPS_LED_CONTROL_OFFSET 0
#define LED_REG_OFFSET 8

/**
 * struct led_patterns_dev - Private led patterns device struct.
 * @base_addr: Pointer to the component's base address
 * @hps_led_control: Address of the hps_led_control register
 * @base_period: Address of the base_period register
 * @led_reg: Address of the led_reg register
 * 
 * An led_patterns_dev struct get created for each led patterns component.
 */
struct led_patterns_dev {
	void __iomem *base_addr;
	void __iomem *hps_led_control;
	void __iomem *base_period;
	void __iomem *led_reg;
	struct miscdevice miscdev;
	struct mutex lock;
};

/**
 * led_patterns_probe() - Initialize device when a match is found
 * @pdev: Platform device structure associated with our led patters device;
 *	pdev is automatially created by the driver core based upon our 
 *	led patterns device tree node.
 * 
 * When a device that is caompatible with this led patterns driver is found, the 
 * driver's probe function is called. This probe function gets called by the 
 * kernel when an led_patterns device is found in the device tree.
 */
static int led_patterns_probe(struct platform_device *pdev){
	struct led_patterns_dev *priv;
	size_t ret;
	
	/*
	 * Allocate kernel memory for the led patterns device and set it to 0.
	 * GFP_KERNEL speciries that we are allocating normal kernal RAM;
	 * see the kmalloc documentation for more info. The allocated memory
	 * is automatically freed when the device is removed.
	 */
	priv = devm_kzalloc(&pdev->dev, sizeof(struct led_patterns_dev),
			   GFP_KERNEL);
	if(!priv){
		pr_err("Failed to allocate memory\n");
		return -ENOMEM;
	}
	
	/*
	 * Request and remap the device's memory region. Requesting the region
	 * make sure nobody else can use that memory. The memory is remapped 
	 * into the kernel's virtual address space because we don't have acess
	 * to physical memory locations.
	 */
	priv->base_addr = devm_platform_ioremap_resource(pdev, 0);
	if(IS_ERR(priv->base_addr)){
		pr_err("Failed to request/remap platform device resource\n");
		return PTR_ERR(priv->base_addr);
	}
	
	// set the memeory addresses for each register.
	priv->hps_led_control = priv->base_addr + HPS_LED_CONTROL_OFFSET;
	priv->base_period = priv->base_addr + BASE_PERIOD_OFFSET;
	priv->led_reg = priv->base_addr + LED_REG_OFFSET;
	
	// enable software-control mode and turn all the LEDs on, just for fun.
	iowrite32(1, priv->hps_led_control);
	iowrite32(0xff, priv->led_reg);
	
	//Initialize the misc device parameters
	priv->miscdev.minor = MISC_DYNAMIC_MINOR;
	priv->miscdev.name = "led_patterns";
	priv->miscdev.fops = &led_patterns_fops;
	priv->miscdev.parent = &pdev->dev;

	//Register the misc device; this creates a char dev at /dev/led_patterns
	ret = misc_register(&priv->miscdev);
	if(ret){
		pr_err("Failed to register misc device");
		return ret;


	/* Attach the led pattern's private data to the platform device's struct.
	 * This is so we can access our state container in the other functions.
	 */
	platform_set_drvdata(pdev, priv);
	
	pr_info("led_patterns_probe successful\n");
	return 0;
}

/**
 * led_patterns_remove() - Remove an led patterns device.
 * @pdev: Platform device structure associated with our led patterns device.
 *
 * This function is called when an led patterns device is removed or
 * the driver is removed.
 */
static int led_patterns_remove(struct platform_device *pdev){
	// Get the led pattern's private data from the platform device.
	struct led_patterns_dev *priv = platform_get_drvdata(pdev);
	
	// Disable software-control mode, just for laughs.
	iowrite32(0, priv->hps_led_control);
	// Deregister the misc device and remove the /dev/led_patterns file.
	misc_deregister(&priv->miscdev);
	pr_info("led_patterns_remove successful\n");
	return 0;
}

/*
 * Define the compatible property used for matching devices to this driver,
 * then add our device id structure to the kernel's device table. For a device
 * to be matched with this driver, its device tree node must use the same 
 * compatible string as defined here.
 */
static const struct of_device_id led_patterns_of_match[] = {
	{ .compatible = "crittenden,led_patterns", },
	{ }
};
MODULE_DEVICE_TABLE(of, led_patterns_of_match);

/*
 * struct led_patterns_driver - Platform driver struct for the led patterns driver
 * @probe: Function that's called when a device is found
 * @remove: Function that's called when a device is removed
 * @driver.owner: Which module owns this driver
 * @driver.name: Name of the led_patters driver
 * @driver.of_match_table: Device tree match table
 */
static struct platform_driver led_patterns_driver = {
	.probe = led_patterns_probe,
	.remove = led_patterns_remove,
	.driver = {
		.owner = THIS_MODULE,
		.name = "led_patterns",
		.of_match_table = led_patterns_of_match,
	},
};

/*
 * We don't need to do anything special in module init/exti.
 * this macro automatially handles module init/exit.
 */
module_platform_driver(led_patterns_driver);

MODULE_LICENSE("Dual MIT/GPL");
MODULE_AUTHOR("Ian Crittenden");
MODULE_DESCRIPTION("led_patterns driver");
	
