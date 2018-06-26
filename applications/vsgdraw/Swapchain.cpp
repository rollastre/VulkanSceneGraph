#include "vulkan/Device.h"
#include "vulkan/Surface.h"
#include "vulkan/Swapchain.h"

#include <limits>

namespace vsg
{

struct SwapChainSupportDetails
{
    VkSurfaceCapabilitiesKHR        capabilities;
    std::vector<VkSurfaceFormatKHR> formats;
    std::vector<VkPresentModeKHR>   presentModes;
};

SwapChainSupportDetails querySwapChainSupport(VkPhysicalDevice device, VkSurfaceKHR surface)
{
    SwapChainSupportDetails details;

    vkGetPhysicalDeviceSurfaceCapabilitiesKHR(device, surface, &details.capabilities);

    uint32_t formatCount;
    vkGetPhysicalDeviceSurfaceFormatsKHR(device, surface, &formatCount, nullptr);

    details.formats.resize(formatCount);
    if (formatCount>0)
    {
        vkGetPhysicalDeviceSurfaceFormatsKHR(device, surface, &formatCount, details.formats.data());
    }

    uint32_t presentModeCount;
    vkGetPhysicalDeviceSurfacePresentModesKHR(device, surface, &presentModeCount, nullptr);

    details.presentModes.resize(presentModeCount);
    if (presentModeCount>0)
    {
        vkGetPhysicalDeviceSurfacePresentModesKHR(device, surface, &presentModeCount, details.presentModes.data());
    }

    return details;
}

VkSurfaceFormatKHR selectSwapSurfaceFormat(SwapChainSupportDetails& details)
{
    if (details.formats.empty() || (details.formats.size()==1 && details.formats[0].format==VK_FORMAT_UNDEFINED))
    {
        std::cout<<"selectSwapSurfaceFormat() VK_FORMAT_UNDEFINED, so using fallbalck "<<std::endl;
        return {VK_FORMAT_B8G8R8A8_UNORM, VK_COLOR_SPACE_SRGB_NONLINEAR_KHR};
    }

    for (const auto& availableFormat : details.formats)
    {
        if (availableFormat.format==VK_FORMAT_B8G8R8A8_UNORM &&
            availableFormat.colorSpace==VK_COLOR_SPACE_SRGB_NONLINEAR_KHR)
        {
            return availableFormat;
        }
    }

    return details.formats[0];
}

VkExtent2D selectSwapExtent(SwapChainSupportDetails& details, uint32_t width, uint32_t height)
{
    VkSurfaceCapabilitiesKHR& capabilities = details.capabilities;

    if (capabilities.currentExtent.width != std::numeric_limits<uint32_t>::max())
    {
        return capabilities.currentExtent;
    }
    else
    {
        VkExtent2D extent;
        extent.width = std::max(capabilities.minImageExtent.width, std::min(capabilities.maxImageExtent.width, width));
        extent.height = std::max(capabilities.minImageExtent.height, std::min(capabilities.maxImageExtent.height, height));
        return extent;
    }
}

VkPresentModeKHR selectSwapPresentMode(SwapChainSupportDetails& details)
{
    VkPresentModeKHR presentMode = VK_PRESENT_MODE_FIFO_KHR;

    for (const auto& availablePresentMode : details.presentModes)
    {
        if (availablePresentMode==VK_PRESENT_MODE_MAILBOX_KHR) return availablePresentMode;
        else if (availablePresentMode==VK_PRESENT_MODE_IMMEDIATE_KHR) presentMode = availablePresentMode;
    }

    return presentMode;
}

Swapchain::Swapchain(PhysicalDevice* physicalDevice, Device* device, Surface* surface, uint32_t width, uint32_t height, VkAllocationCallbacks*  pAllocator):
    _device(device), _surface(surface), _swapchain(VK_NULL_HANDLE), _pAllocator(pAllocator)
{
    SwapChainSupportDetails details = querySwapChainSupport(*physicalDevice, *surface);

    VkSurfaceFormatKHR surfaceFormat = selectSwapSurfaceFormat(details);
    VkPresentModeKHR presentMode = selectSwapPresentMode(details);
    VkExtent2D extent = selectSwapExtent(details, width, height);


    uint32_t imageCount = details.capabilities.minImageCount+1;
    if (details.capabilities.maxImageCount>0 && imageCount>details.capabilities.maxImageCount)
    {
        imageCount = details.capabilities.maxImageCount;
    }

    VkSwapchainCreateInfoKHR createInfo = {};
    createInfo.sType = VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR;
    createInfo.surface = *surface;

    createInfo.minImageCount = imageCount;
    createInfo.imageFormat = surfaceFormat.format;
    createInfo.imageColorSpace = surfaceFormat.colorSpace;
    createInfo.imageExtent = extent;
    createInfo.imageArrayLayers = 1;
    createInfo.imageUsage = VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT;

    if (physicalDevice->getGraphicsFamily()!=physicalDevice->getPresentFamily())
    {
        uint32_t queueFamilyIndices[] = { uint32_t(physicalDevice->getGraphicsFamily()), uint32_t(physicalDevice->getPresentFamily()) };
        createInfo.imageSharingMode = VK_SHARING_MODE_CONCURRENT;
        createInfo.queueFamilyIndexCount = 2;
        createInfo.pQueueFamilyIndices = queueFamilyIndices;
    }
    else
    {
        createInfo.imageSharingMode = VK_SHARING_MODE_EXCLUSIVE;
    }

    createInfo.preTransform = details.capabilities.currentTransform;
    createInfo.compositeAlpha = VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR;
    createInfo.presentMode = presentMode;
    createInfo.clipped = VK_TRUE;

    createInfo.oldSwapchain = VK_NULL_HANDLE;

    _format = surfaceFormat.format;
    _extent = extent;

    if (vkCreateSwapchainKHR(*_device, &createInfo, nullptr, &_swapchain)!=VK_SUCCESS)
    {
        std::cout<<"Failed to create swap chain"<<std::endl;
        return;

    }


    // create the ImageViews
    std::vector<VkImage> images;
    vkGetSwapchainImagesKHR(*_device, _swapchain, &imageCount, nullptr);
    images.resize(imageCount);
    vkGetSwapchainImagesKHR(*_device, _swapchain, &imageCount, images.data());

    for (std::size_t i=0; i<images.size(); ++i)
    {
        VkImageViewCreateInfo createInfo = {};
        createInfo.sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
        createInfo.image = images[i];
        createInfo.viewType = VK_IMAGE_VIEW_TYPE_2D;
        createInfo.format = _format;
        createInfo.components.r = VK_COMPONENT_SWIZZLE_IDENTITY;
        createInfo.components.g = VK_COMPONENT_SWIZZLE_IDENTITY;
        createInfo.components.b = VK_COMPONENT_SWIZZLE_IDENTITY;
        createInfo.components.a = VK_COMPONENT_SWIZZLE_IDENTITY;
        createInfo.subresourceRange.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
        createInfo.subresourceRange.baseMipLevel = 0;
        createInfo.subresourceRange.levelCount = 1;
        createInfo.subresourceRange.baseArrayLayer = 0;
        createInfo.subresourceRange.layerCount = 1;

        VkImageView view;
        if (vkCreateImageView(*_device, &createInfo, nullptr, &view)==VK_SUCCESS)
        {
            _imageViews.push_back(new ImageView(_device.get(), view, _pAllocator));
        }
        else
        {
            std::cout<<"Error : unable to create image view "<<i<<std::endl;
        }
    }
}

Swapchain::~Swapchain()
{
    _imageViews.clear();

    if (_swapchain)
    {
        std::cout<<"Calling vkDestroySwapchainKHR(..)"<<std::endl;
        vkDestroySwapchainKHR(*_device, _swapchain, _pAllocator);
    }
}


}
