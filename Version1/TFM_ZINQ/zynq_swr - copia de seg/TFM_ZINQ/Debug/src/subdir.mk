################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
LD_SRCS += \
../src/lscript.ld 

C_SRCS += \
../src/ads1298r_api.c \
../src/gic_api.c \
../src/main.c \
../src/spi_api.c 

OBJS += \
./src/ads1298r_api.o \
./src/gic_api.o \
./src/main.o \
./src/spi_api.o 

C_DEPS += \
./src/ads1298r_api.d \
./src/gic_api.d \
./src/main.d \
./src/spi_api.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -IC:/Users/victo/Desktop/TFM/Zynq/TFM_ZINQ/zynq_swr/TFM_ZYNQ_wrapper/export/TFM_ZYNQ_wrapper/sw/TFM_ZYNQ_wrapper/standalone_domain/bspinclude/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


