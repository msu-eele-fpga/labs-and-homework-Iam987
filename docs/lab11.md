##
# Lab 11 - Platform Device Driver
## Overview
In this Lab, I created a device driver for the led patterns hardware component.  The device tree was modified to include the led_patterns device. The device was given attributes so that the register could be written to in a file. Bash scripts were also used to manipulate the device's attributes.
## Deliverables
### None, Demos completed 

### Questions
>What is the purpose of the platform bus?  

The platform bus keeps track of devices attached to the OS and what resources they have
>Why is the driver's compatible property important?

The compatible property in the device tree node needs to match the compatible string in the driver; if this is true, the device will get correctly bound to the driver.
>What is the probe function's purpose?

The probe function gets called when an led_patterns device is found in the device tree, it allocates kernel memory for the device, maps the virtual addresses associated with the device, and sets the memory addresses for each register.
>How does your driver know what memory addresses are associated with your device?

The memory addresses are mapped in the probe function.
>What are the two ways we can write to our device's registers? In other words, what subsystems do we use to write to our registers?

Devmem and iowrite32
>What is the purpose of our struct led_patterns_dev state container?

The led_patterns_dev state container allows the kernel to perform some code-correctness checks because we tell it that our memory addresses point to I/O memory (specifically, each register of our device)