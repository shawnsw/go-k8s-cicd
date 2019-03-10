# 0kb base
FROM scratch
# add the binary built outside
ADD main /
# run the binary
CMD ["/main"]
