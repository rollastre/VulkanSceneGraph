/* <editor-fold desc="MIT License">

Copyright(c) 2018 Robert Osfield

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

</editor-fold> */

#include <vsg/io/Options.h>
#include <vsg/state/VertexInputState.h>
#include <vsg/vk/Context.h>

using namespace vsg;

VertexInputState::VertexInputState()
{
}

VertexInputState::VertexInputState(const Bindings& bindings, const Attributes& attributes) :
    vertexBindingDescriptions(bindings),
    vertexAttributeDescriptions(attributes)
{
}

VertexInputState::~VertexInputState()
{
}

void VertexInputState::read(Input& input)
{
    Object::read(input);

    vertexBindingDescriptions.resize(input.readValue<uint32_t>("NumBindings"));
    for (auto& binding : vertexBindingDescriptions)
    {
        input.read("binding", binding.binding);
        input.read("stride", binding.stride);
        input.readValue<uint32_t>("inputRate", binding.inputRate);
    }

    vertexAttributeDescriptions.resize(input.readValue<uint32_t>("NumAttributes"));
    for (auto& attribute : vertexAttributeDescriptions)
    {
        input.read("location", attribute.location);
        input.read("binding", attribute.binding);
        input.readValue<uint32_t>("format", attribute.format);
        input.read("offset", attribute.offset);
    }
}

void VertexInputState::write(Output& output) const
{
    Object::write(output);

    output.writeValue<uint32_t>("NumBindings", vertexBindingDescriptions.size());
    for (auto& binding : vertexBindingDescriptions)
    {
        output.write("binding", binding.binding);
        output.write("stride", binding.stride);
        output.writeValue<uint32_t>("inputRate", binding.inputRate);
    }

    output.writeValue<uint32_t>("NumAttributes", vertexAttributeDescriptions.size());
    for (auto& attribute : vertexAttributeDescriptions)
    {
        output.write("location", attribute.location);
        output.write("binding", attribute.binding);
        output.writeValue<uint32_t>("format", attribute.format);
        output.write("offset", attribute.offset);
    }
}

void VertexInputState::apply(Context& context, VkGraphicsPipelineCreateInfo& pipelineInfo) const
{
    auto vertexInputState = context.scratchMemory->allocate<VkPipelineVertexInputStateCreateInfo>();

    vertexInputState->sType = VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO;
    vertexInputState->pNext = nullptr;
    vertexInputState->flags = 0;
    vertexInputState->vertexBindingDescriptionCount = static_cast<uint32_t>(vertexBindingDescriptions.size());
    vertexInputState->pVertexBindingDescriptions = vertexBindingDescriptions.data();
    vertexInputState->vertexAttributeDescriptionCount = static_cast<uint32_t>(vertexAttributeDescriptions.size());
    vertexInputState->pVertexAttributeDescriptions = vertexAttributeDescriptions.data();

    pipelineInfo.pVertexInputState = vertexInputState;
}
