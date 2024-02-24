################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
LD_SRCS += \
../src/lscript.ld 

C_SRCS += \
../src/ads1298r_api.c \
../src/dma_api.c \
../src/gic_api.c \
../src/main.c \
../src/platform.c \
../src/spi_api.c 

OBJS += \
./src/ads1298r_api.o \
./src/dma_api.o \
./src/gic_api.o \
./src/main.o \
./src/platform.o \
./src/spi_api.o 

C_DEPS += \
./src/ads1298r_api.d \
./src/dma_api.d \
./src/gic_api.d \
./src/main.d \
./src/platform.d \
./src/spi_api.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -IC:/Users/victo/Desktop/TFM/Zynq/TFM_ZYNQ_4/software/TFM_ZYNQ_4_wrapper/export/TFM_ZYNQ_4_wrapper/sw/TFM_ZYNQ_4_wrapper/standalone_domain/bspinclude/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


