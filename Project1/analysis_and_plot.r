library(dplyr)
library(ggplot2)
library(plotly)
library(readr)
library(tidyr)
library(latex2exp)

# Read data, transform into tidy dataset
data <- read_csv('data.csv') %>%
  gather(Position, TemperatureAnomaly, -Year) %>%
  mutate(TemperatureAnomaly = TemperatureAnomaly / 100)

# Plot yearly variation of global temperature + smoothed fit
ggplot(data=filter(data, Position=="Glob")) +
  geom_line(aes(Year, TemperatureAnomaly), color='gray') +
  geom_point(aes(Year, TemperatureAnomaly, fill='Data')) +
  geom_smooth(aes(Year, TemperatureAnomaly, color="Fit")) +
  ylab("Global temperature anomaly (°C)") +
  ggtitle("Yearly temperature anomaly (global)") +
  guides(color = guide_legend(element_blank()),
         fill = guide_legend(element_blank())) +
  ylab(latex2exp("Global temperature anomaly ($\\degree$C)")) +
  theme(legend.position=c(0.9, 1.05), legend.box="horizontal", legend.margin=unit(1, 'cm'),
        plot.title=element_text(hjust=0, vjust=1))

print(global)

# Read data, keep only measures over longitude chunks, transform into tidy dataset
data2 <- read_csv('data.csv') %>%
  select(-(Glob:`90S-24S`)) %>%
  gather(Position, TemperatureAnomaly, -Year) %>%
  mutate(TemperatureAnomaly = TemperatureAnomaly / 100)

# Plot temperature as a heatmap as a function of year & longitude chunk
by_latitude <- ggplot(data=data2) +
  geom_tile(aes(x=Year, y=Position, fill=TemperatureAnomaly)) +
  scale_fill_distiller(type='div', palette="RdBu", trans="reverse",
                       guide=guide_colorbar(title=element_text("Temperature\nanomaly (°C)"),
                                            direction="horizontal")) +
  scale_y_discrete(limits=rev(levels(data2$Position))) +
  ylab("Latitude") +
  ggtitle("Yearly temperature anomaly (by latitude)") +
  theme(legend.position=c(0.8, 1.05), legend.box="horizontal", legend.margin=unit(1, 'cm'),
        plot.title=element_text(hjust=0, vjust=1))


print(by_latitude)
