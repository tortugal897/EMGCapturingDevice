################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
LD_SRCS += \
../src/lscript.ld 

C_SRCS += \
../src/ads1298r_api.c \
../src/dma_api.c \
../src/echo.c \
../src/ethernet.c \
../src/gic_api.c \
../src/i2c_access.c \
../src/iic_phyreset.c \
../src/main.c \
../src/platform.c \
../src/platform_mb.c \
../src/platform_ppc.c \
../src/platform_zynq.c \
../src/platform_zynqmp.c \
../src/ps7_init.c \
../src/sfp.c \
../src/si5324.c \
../src/spi_api.c 

OBJS += \
./src/ads1298r_api.o \
./src/dma_api.o \
./src/echo.o \
./src/ethernet.o \
./src/gic_api.o \
./src/i2c_access.o \
./src/iic_phyreset.o \
./src/main.o \
./src/platform.o \
./src/platform_mb.o \
./src/platform_ppc.o \
./src/platform_zynq.o \
./src/platform_zynqmp.o \
./src/ps7_init.o \
./src/sfp.o \
./src/si5324.o \
./src/spi_api.o 

C_DEPS += \
./src/ads1298r_api.d \
./src/dma_api.d \
./src/echo.d \
./src/ethernet.d \
./src/gic_api.d \
./src/i2c_access.d \
./src/iic_phyreset.d \
./src/main.d \
./src/platform.d \
./src/platform_mb.d \
./src/platform_ppc.d \
./src/platform_zynq.d \
./src/platform_zynqmp.d \
./src/ps7_init.d \
./src/sfp.d \
./src/si5324.d \
./src/spi_api.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -Wall -O2 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -IC:/Users/victo/Desktop/TFM/Zynq/TFM_ZYNQ_ETHERNET/software_TFM/TFM_ZYNQ_4_wrapper/export/TFM_ZYNQ_4_wrapper/sw/TFM_ZYNQ_4_wrapper/standalone_domain/bspinclude/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


